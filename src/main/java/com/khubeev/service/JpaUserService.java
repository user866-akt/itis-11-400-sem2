package com.khubeev.service;

import com.khubeev.dto.UserDto;
import com.khubeev.model.Role;
import com.khubeev.model.User;
import com.khubeev.repository.JpaUserRepository;
import com.khubeev.repository.RoleRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional(value = "jpaTransactionManager")
public class JpaUserService {

    private final JpaUserRepository jpaUserRepository;
    private final PasswordEncoder passwordEncoder;
    private final RoleRepository roleRepository;

    public JpaUserService(JpaUserRepository jpaUserRepository,
                          PasswordEncoder passwordEncoder,
                          RoleRepository roleRepository) {
        this.jpaUserRepository = jpaUserRepository;
        this.passwordEncoder = passwordEncoder;
        this.roleRepository = roleRepository;
    }

    private UserDto convertToDto(User user) {
        return new UserDto(user.getId(), user.getUsername());
    }

    @Transactional(value = "jpaTransactionManager", readOnly = true)
    public List<UserDto> findAll() {
        return jpaUserRepository.findAll().stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }

    @Transactional(value = "jpaTransactionManager", readOnly = true)
    public UserDto findById(Long id) {
        return jpaUserRepository.findById(id)
                .map(this::convertToDto)
                .orElse(null);
    }

    @Transactional(value = "jpaTransactionManager", readOnly = true)
    public UserDto findByUsername(String username) {
        return jpaUserRepository.findByUsername(username)
                .map(this::convertToDto)
                .orElse(null);
    }

    @Transactional(value = "jpaTransactionManager")
    public UserDto createUser(String username, String rawPassword) {
        if (username == null || username.trim().isEmpty()) {
            throw new IllegalArgumentException("Username can't be empty!");
        }
        if (rawPassword == null || rawPassword.trim().isEmpty()) {
            throw new IllegalArgumentException("Password can't be empty!");
        }
        if (jpaUserRepository.findByUsername(username).isPresent()) {
            throw new IllegalArgumentException("Username already exists!");
        }

        Role userRole = roleRepository.findByName("ROLE_USER")
                .orElseThrow(() -> new RuntimeException("Default role 'ROLE_USER' not found in database"));

        User user = new User();
        user.setUsername(username);
        user.setPassword(passwordEncoder.encode(rawPassword));
        user.setRoles(List.of(userRole));

        User savedUser = jpaUserRepository.saveAndFlush(user);
        return convertToDto(savedUser);
    }

    @Transactional(value = "jpaTransactionManager")
    public UserDto updateUser(Long id, String username) {
        User user = jpaUserRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found with id: " + id));
        user.setUsername(username);
        User updatedUser = jpaUserRepository.saveAndFlush(user);
        return convertToDto(updatedUser);
    }

    @Transactional(value = "jpaTransactionManager")
    public void deleteUser(Long id) {
        jpaUserRepository.deleteById(id);
        jpaUserRepository.flush();
    }
}