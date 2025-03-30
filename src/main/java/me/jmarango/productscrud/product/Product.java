package me.jmarango.productscrud.product;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import me.jmarango.productscrud.image.Image;
import me.jmarango.productscrud.user.User;
import org.springframework.data.annotation.CreatedDate;

import java.time.Instant;
import java.util.List;

@Entity
@Getter
@Setter
@Table(name = "products")
@NoArgsConstructor
@AllArgsConstructor
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(nullable = false)
    private Long id;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private String description;

    @ManyToOne(optional = false)
    @JoinColumn(name = "author_id", nullable = false)
    private User author;

    @OneToOne(optional = false)
    @JoinColumn(name = "image_id", nullable = false)
    private Image mainImage;

    @OneToMany(mappedBy = "product")
    private List<Image> additionalImages;

    @Column(nullable = false)
    private float price;

    @CreatedDate
    private Instant createdAt = Instant.now();
}
