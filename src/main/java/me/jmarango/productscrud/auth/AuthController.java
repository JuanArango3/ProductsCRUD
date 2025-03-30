package me.jmarango.productscrud.auth;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import me.jmarango.base.exception.UserWithUsernameAlreadyExistsException;
import me.jmarango.productscrud.auth.service.AuthService;
import me.jmarango.security.dto.request.LoginRequest;
import me.jmarango.security.dto.request.RegisterRequest;
import me.jmarango.security.dto.response.TokenResponse;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/auth")
public class AuthController {
    private final AuthService authService;

    @PostMapping("/login")
    public TokenResponse login(@Valid @RequestBody LoginRequest request) {
        return authService.authenticate(request);
    }

    @PostMapping("/register")
    public TokenResponse register(@Valid @RequestBody RegisterRequest request) throws UserWithUsernameAlreadyExistsException {
        return authService.register(request);
    }
}
