package me.jmarango.productscrud.product;

import io.swagger.v3.oas.annotations.Parameter;
import javax.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import me.jmarango.base.dto.request.PageableRequest;
import me.jmarango.base.dto.response.page.PageInfo;
import me.jmarango.base.exception.NotFoundException;
import me.jmarango.productscrud.product.dto.CreateProductRequest;
import me.jmarango.productscrud.product.dto.ProductDTO;
import me.jmarango.productscrud.user.User;
import me.jmarango.security.annotations.RequireAuthority;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/product")
@Slf4j
public class ProductController {
    private final ProductService productService;

    @GetMapping("/{id}")
    public ProductDTO getProductById(@PathVariable Long id) {
        Product product = productService.getProductById(id);
        if (product == null) throw new NotFoundException("Product not found");

        return productService.mapToDTO(product);
    }

    @GetMapping
    public PageInfo<ProductDTO> getProducts(PageableRequest request) {
        return productService.getProducts(request);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @RequireAuthority("ROLE_ADMIN")
    public ProductDTO createProduct(@RequestBody @Valid CreateProductRequest request, @Parameter(hidden = true) User user) {
        ProductDTO dto = ProductDTO.builder()
                .name(request.name())
                .description(request.description())
                .price(request.price())
                .imageIds(request.imageIds())
                .authorId(user.getId())
                .build();
        return productService.mapToDTO(productService.createProduct(dto));
    }

    @PutMapping
    @RequireAuthority("ROLE_ADMIN")
    public ProductDTO updateProduct(@RequestBody @Valid ProductDTO dto) {
        return productService.mapToDTO(productService.updateProduct(dto));
    }

    @DeleteMapping("/{id}")
    @RequireAuthority("ROLE_ADMIN")
    public void deleteProduct(@PathVariable Long id) {
        productService.deleteProduct(id);
    }
}
