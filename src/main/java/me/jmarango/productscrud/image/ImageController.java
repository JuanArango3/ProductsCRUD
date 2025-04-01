package me.jmarango.productscrud.image;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import me.jmarango.base.exception.NotFoundException;
import me.jmarango.base.exception.code.BadRequestException;
import me.jmarango.productscrud.image.validators.AspectRatio;
import me.jmarango.security.annotations.RequireAuthority;
import org.springframework.http.CacheControl;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.time.Duration;
import java.util.Set;
import java.util.UUID;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/image")
@Slf4j
public class ImageController {

    private final ImageService imageService;

    private final AspectRatio landscapeValidator = new AspectRatio(AspectRatio.Type.LANDSCAPE);

    @GetMapping("/{id}")
    public void getImageById(@PathVariable String id, HttpServletResponse response) {
        try {
            byte[] image = imageService.readImage(id);
            response.setContentType("image/webp");
            response.setContentLength(image.length);

            CacheControl cacheControl = CacheControl.maxAge(Duration.ofDays(365)).cachePublic();
            response.setHeader("Cache-Control", cacheControl.getHeaderValue());

            ServletOutputStream out = response.getOutputStream();
            out.write(image);
            out.flush();

        }  catch (NotFoundException | IllegalArgumentException e) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            log.error("Error retrieving image", e);
        }
    }

    @PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @ResponseStatus(HttpStatus.CREATED)
    @RequireAuthority("ROLE_ADMIN")
    public String uploadImage(@RequestParam("file") MultipartFile file) {
        try {
            return imageService.uploadImage(file, Set.of(landscapeValidator)).getId().toString();
        } catch (IllegalArgumentException | ImageValidationException e) {
            throw new BadRequestException(e.getMessage());
        } catch (Exception e) {
            log.error("Error uploading image", e);
            throw new RuntimeException("Error uploading image", e);
        }
    }


}
