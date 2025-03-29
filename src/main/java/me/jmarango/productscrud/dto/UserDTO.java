package me.jmarango.productscrud.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import me.jmarango.productscrud.entity.User;
import org.hibernate.validator.constraints.Length;

import java.io.Serializable;

/**
 * DTO for {@link me.jmarango.productscrud.entity.User}
 */
public record UserDTO(
        Long id,
        @Pattern(regexp = "^[a-zA-Z0-9]+$") @Length(min = 3, max = 16) String username,
        @NotBlank String password,
        User.Role role
) implements Serializable {
}