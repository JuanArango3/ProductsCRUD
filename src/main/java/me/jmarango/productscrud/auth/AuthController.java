package me.jmarango.productscrud.auth;

import io.swagger.v3.oas.annotations.Parameter;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import me.jmarango.base.exception.UserWithUsernameAlreadyExistsException;
import me.jmarango.productscrud.auth.service.AuthService;
import me.jmarango.productscrud.user.User;
import me.jmarango.productscrud.user.UserDTO;
import me.jmarango.productscrud.user.UserService;
import me.jmarango.security.annotations.RequireAuth;
import me.jmarango.security.dto.request.LoginRequest;
import me.jmarango.security.dto.request.RegisterRequest;
import me.jmarango.security.dto.response.TokenResponse;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/auth")
public class AuthController {
    private final AuthService authService;

    private final UserService userService;

    @PostMapping("/login")
    public TokenResponse login(@Valid @RequestBody LoginRequest request) {
        return authService.authenticate(request);
    }

    @PostMapping("/register")
    public TokenResponse register(@Valid @RequestBody RegisterRequest request) throws UserWithUsernameAlreadyExistsException {
        return authService.register(request);
    }

    @GetMapping("/me")
    @RequireAuth
    public UserDTO me(@Parameter(hidden = true) User user) {
        return userService.mapToDTO(user);
    }
}
