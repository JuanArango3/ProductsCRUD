package me.jmarango.productscrud.repository;

import me.jmarango.productscrud.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {
}