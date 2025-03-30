package me.jmarango.productscrud.image;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import me.jmarango.productscrud.product.Product;
import org.springframework.data.annotation.CreatedDate;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "images")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Image {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(nullable = false)
    private UUID id;

    @ManyToMany(mappedBy = "images")
    private List<Product> product;

    @OneToOne(mappedBy = "mainImage")
    private Product productImage;

    @CreatedDate
    Instant dateUploaded = Instant.now();
}
