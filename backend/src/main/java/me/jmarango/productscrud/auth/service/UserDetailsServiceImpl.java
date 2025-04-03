package me.jmarango.productscrud.auth.service;

import lombok.RequiredArgsConstructor;
import me.jmarango.productscrud.user.User;
import me.jmarango.productscrud.user.UserService;
import me.jmarango.security.dto.EnderUserDetails;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class UserDetailsServiceImpl implements UserDetailsService {

    private final UserService userService;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user;

        user = userService.getUserByUsername(username);
        if (user == null) throw new UsernameNotFoundException(username+" not found");

        return new EnderUserDetails(
                user.getId(),
                user.getUsername(),
                user.getPassword(),
                Instant.now(),
                getAuthorities(user)
        );
    }

    public Set<GrantedAuthority> getAuthorities(User user) {
        return Set.of(user.getRole());
    }
}
