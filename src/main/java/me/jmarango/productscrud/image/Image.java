package me.jmarango.productscrud.image;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import me.jmarango.productscrud.product.Product;
import org.springframework.data.annotation.CreatedDate;

import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "images")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Image {
    @Id
    @Column(nullable = false)
    private UUID id = UUID.randomUUID();

    @ManyToOne
    private Product product;

    @CreatedDate
    Instant dateUploaded = Instant.now();
}
