package me.jmarango.productscrud.user;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import org.hibernate.validator.constraints.Length;

import java.io.Serializable;

/**
 * DTO for {@link User}
 */
public record UserDTO(
        Long id,
        @Pattern(regexp = "^[a-zA-Z0-9]+$") @Length(min = 3, max = 16) String username,
        @NotBlank String password,
        User.Role role
) implements Serializable {
}