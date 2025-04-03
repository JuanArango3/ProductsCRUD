package me.jmarango.productscrud.product.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotEmpty;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import me.jmarango.productscrud.product.Product;

import java.io.Serializable;
import java.util.List;
import java.util.UUID;

/**
 * DTO for {@link Product}
 */

@JsonIgnoreProperties(ignoreUnknown = true)
@Getter
@Setter
@Builder
public class ProductDTO implements Serializable {
    Long id;
    @NotBlank String name;
    @NotBlank String description;
    Long authorId;

    @NotEmpty(message = "Product must have at least one image")
    List<UUID> imageIds;
    @Min(0) Float price;
}