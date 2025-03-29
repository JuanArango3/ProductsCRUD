package me.jmarango.productscrud.repository;

import me.jmarango.productscrud.entity.Product;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProductRepository extends JpaRepository<Product, Long> {
}