package me.jmarango.productscrud.user;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonInclude;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Pattern;
import org.hibernate.validator.constraints.Length;

import java.io.Serializable;

/**
 * DTO for {@link User}
 */

public record UserDTO(
        Long id,
        @Pattern(regexp = "^[a-zA-Z0-9]+$") @Length(min = 3, max = 16) String username,
        @NotBlank @JsonInclude(JsonInclude.Include.NON_NULL) String password,
        User.Role role
) implements Serializable {
}