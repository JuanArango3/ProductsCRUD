package me.jmarango.productscrud.auth.service;

import lombok.RequiredArgsConstructor;
import me.jmarango.base.exception.UserWithUsernameAlreadyExistsException;
import me.jmarango.productscrud.user.UserDTO;
import me.jmarango.productscrud.user.User;
import me.jmarango.productscrud.user.UserService;
import me.jmarango.security.dto.EnderUserDetails;
import me.jmarango.security.dto.request.LoginRequest;
import me.jmarango.security.dto.request.RefreshTokenRequest;
import me.jmarango.security.dto.request.RegisterRequest;
import me.jmarango.security.dto.response.TokenResponse;
import me.jmarango.security.exceptions.NoAuthenticatedException;
import me.jmarango.security.service.IAuthenticationService;
import me.jmarango.security.utils.JwtUtils;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthService implements IAuthenticationService {

    private final AuthenticationManager authManager;

    private final JwtUtils jwtUtils;

    private final UserDetailsServiceImpl userDetailsService;
    private final UserService userService;

    @Override
    public <T extends LoginRequest> TokenResponse authenticate(T request) throws BadCredentialsException {
        Authentication authentication = authManager.authenticate(new UsernamePasswordAuthenticationToken(request.getUsername(), request.getPassword()));

        EnderUserDetails user = (EnderUserDetails) authentication.getPrincipal();
        String token = jwtUtils.generateToken(user);

        return new TokenResponse(token, null);
    }

    @Override
    public TokenResponse refreshToken(RefreshTokenRequest request, boolean isShortDuration) throws NoAuthenticatedException {
        return null;
    }

    @Override
    public <T extends RegisterRequest> TokenResponse register(T request) throws UserWithUsernameAlreadyExistsException {
        if (userService.getUserByUsername(request.getUsername()) != null)
            throw new UserWithUsernameAlreadyExistsException(request.getUsername());

        UserDTO newUser = new UserDTO(null, request.getUsername(), request.getPassword(), User.Role.USER);
        User user = userService.create(newUser);

        String token = jwtUtils.generateToken(new EnderUserDetails(user.getId(), user.getUsername(), null, null, userDetailsService.getAuthorities(user)));

        return new TokenResponse(token, null);
    }
}
