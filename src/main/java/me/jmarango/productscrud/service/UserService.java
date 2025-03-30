package me.jmarango.productscrud.service;

import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import me.jmarango.base.exception.NotFoundException;
import me.jmarango.productscrud.dto.UserDTO;
import me.jmarango.productscrud.entity.User;
import me.jmarango.productscrud.repository.UserRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Slf4j
public class UserService {

    private final UserRepository userRepository;

    private final PasswordEncoder passwordEncoder;

    public User create(UserDTO userDTO) {
        User user = new User();
        user.setUsername(userDTO.username());
        user.setPassword(passwordEncoder.encode(userDTO.password()));
        user.setRole(userDTO.role());

        return userRepository.save(user);
    }

    public User getUserById(Long id) {
        return userRepository.findById(id).orElse(null);
    }

    public User getUserByUsername(String username) {
        return userRepository.findByUsername(username).orElse(null);
    }

    public UserDTO mapToDTO(User user) {
        return new UserDTO(
                user.getId(),
                user.getUsername(),
                user.getPassword(),
                user.getRole()
        );
    }

    @PostConstruct
    public void init() {
        if (userRepository.count() == 0) {
            create(new UserDTO(null, "admin", "admin", User.Role.ADMIN));
            create(new UserDTO(null, "user", "user", User.Role.USER));
        }
    }
}
