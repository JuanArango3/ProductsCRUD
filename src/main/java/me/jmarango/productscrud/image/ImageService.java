package me.jmarango.productscrud.image;

import com.sksamuel.scrimage.ImmutableImage;
import com.sksamuel.scrimage.webp.WebpWriter;
import jakarta.annotation.PostConstruct;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import me.jmarango.base.exception.NotFoundException;
import me.jmarango.base.exception.code.BadRequestException;
import me.jmarango.productscrud.image.validators.ImageValidator;
import me.jmarango.productscrud.utils.FileUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.unit.DataSize;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.time.Instant;
import java.util.Set;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class ImageService {
    private final ImageRepository imageRepository;

    @Value("${app.data.directory}/images")
    private String uploadDir;

    @Value("${app.data.image.max-size}")
    private DataSize maxImageSize;

    @Getter
    private static final Set<String> allowedMimeTypes = Set.of("image/jpeg", "image/png", "image/gif");

    @Transactional
    public Image uploadImage(MultipartFile file, Set<ImageValidator> validators) {
        if (file.isEmpty()) throw new BadRequestException("Empty file");

        if (!allowedMimeTypes.contains(file.getContentType())) throw new BadRequestException("Invalid file type");

        if (file.getSize() > maxImageSize.toBytes()) throw new BadRequestException("Image too large");

        try {
            ImmutableImage image = ImmutableImage.loader().fromBytes(file.getBytes());

            validators.forEach(validator -> validator.validate(image));

            Image entity = new Image();
            String filename = entity.getId() + ".webp";

            File output = new File(uploadDir, filename);

            convertToWebP(image, output);

            return imageRepository.save(entity);
        } catch (IOException ex) {
            throw new RuntimeException("Error uploading image", ex);
        }
    }

    public void removeImage(Image image) {
        File file = getFile(image.getId().toString());
        if (!file.exists()) {
            log.warn("File {} not found, removing from db", file.getAbsolutePath());
            imageRepository.delete(image);
            return;
        }

        imageRepository.delete(image);
        if (!FileUtils.deleteFile(file)) {
            throw new IllegalStateException("Error deleting file " + file.getAbsolutePath());
        }
        log.info("Deleted file {}", file.getAbsolutePath());
    }

    public Image getImageById(UUID id) {
        return imageRepository.findById(id).orElse(null);
    }

    private void convertToWebP(ImmutableImage immutableImage, File output) throws IOException {
        try {
            immutableImage.output(WebpWriter.DEFAULT, output);
        } catch (IOException ex) {
            throw new IOException("Error converting image", ex);
        }
    }

    private File getFile(String id) {
        return new File(uploadDir, id + ".webp");
    }

    public byte[] readImage(String id) {
        Image image = getImageById(UUID.fromString(id));
        if (image == null) {
            throw new NotFoundException("Image not found");
        }
        File file = getFile(image.getId().toString());

        try {
            return Files.readAllBytes(file.toPath());
        } catch (IOException ex) {
            throw new RuntimeException("Error reading image", ex);
        }
    }


    @PostConstruct
    public void init() {
        File dir = new File(uploadDir);
        if (!dir.exists()) {
            if (!dir.mkdirs()) {
                throw new RuntimeException("Error creating directory " + uploadDir);
            }
        }
    }

    @Scheduled(cron = "0 0 0 * * *")
    @PostConstruct
    @Transactional
    public void deleteUnusedImages() {
        log.info("Cleaning unused images");

        Set<Image> unusedImages = imageRepository.findImagesByUploadedAfter(Instant.now().minus(1, java.time.temporal.ChronoUnit.DAYS));

        unusedImages.forEach(image -> {
            if (image.getProduct() != null) return;
            removeImage(image);
        });
    }
}
