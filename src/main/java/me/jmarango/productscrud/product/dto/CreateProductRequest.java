package me.jmarango.productscrud.product.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;

import java.util.List;
import java.util.UUID;

public record CreateProductRequest(
        @NotBlank String name,
        @NotBlank String description,
        @Min(0) Float price,
        @NotEmpty(message = "Product must have at least one image")List<UUID> imageIds
        ) {
}
