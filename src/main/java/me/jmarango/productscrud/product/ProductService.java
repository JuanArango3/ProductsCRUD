package me.jmarango.productscrud.product;

import lombok.RequiredArgsConstructor;
import me.jmarango.base.dto.request.PageableRequest;
import me.jmarango.base.dto.response.page.PageInfo;
import me.jmarango.base.exception.NotFoundException;
import me.jmarango.base.exception.code.BadRequestException;
import me.jmarango.productscrud.image.Image;
import me.jmarango.productscrud.image.ImageService;
import me.jmarango.productscrud.product.dto.ProductDTO;
import me.jmarango.productscrud.user.User;
import me.jmarango.productscrud.user.UserService;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ProductService {
    private final ProductRepository productRepository;

    private final ImageService imageService;
    private final UserService userService;

    @Transactional
    public Product createProduct(ProductDTO dto) {
        Product product = fillProduct(dto, new Product());

        return productRepository.save(product);
    }

    public Product getProductById(Long id) {
        return productRepository.findById(id).orElse(null);
    }

    public PageInfo<ProductDTO> getProducts(PageableRequest request) {
        var productPage = productRepository.findAll(PageRequest.of(request.getPage(), request.getSize()));
        return new PageInfo<>(
                productPage.getContent().stream().map(this::mapToDTO).collect(Collectors.toList()),
                productPage.getTotalElements(),
                request.getPage(),
                productPage.getTotalPages()
        );
    }

    @Transactional
    public Product updateProduct(ProductDTO dto) {
        Product product = getProductById(dto.getId());
        if (product == null) throw new NotFoundException("Product not found");

        product = fillProduct(dto, product);

        return productRepository.save(product);
    }

    public void deleteProduct(Long id) {
        Product product = getProductById(id);
        if (product == null) throw new NotFoundException("Product not found");

        productRepository.delete(product);
    }


    public ProductDTO mapToDTO(Product product) {
        return ProductDTO.builder()
                .id(product.getId())
                .name(product.getName())
                .description(product.getDescription())
                .price(product.getPrice())
                .authorId(product.getAuthor().getId())
                .imageIds(product.getImages().stream().map(Image::getId).toList())
                .build();
    }

    @Transactional
    public Product fillProduct(ProductDTO dto, Product product) {
        product.setName(dto.getName());
        product.setDescription(dto.getDescription());
        product.setPrice(dto.getPrice());

        User author = userService.getUserById(dto.getAuthorId());
        if (author == null) throw new BadRequestException("Author not found");
        product.setAuthor(author);

        product.setImages(dto.getImageIds().stream().map(uuid -> {
            Image image = imageService.getImageById(uuid);
            if (image == null) throw new BadRequestException("Image not found");
            if (image.getProduct() != null) throw new BadRequestException("Image already used in another product");
            image.setProduct(product);
            return image;
        }).collect(Collectors.toList()));
        return product;
    }
}
