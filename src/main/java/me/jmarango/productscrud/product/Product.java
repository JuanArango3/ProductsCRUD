package me.jmarango.productscrud.product;

import javax.persistence.*;
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


    // La primera imagen es la principal
    @OneToMany(fetch = FetchType.EAGER, mappedBy = "product")
    @OrderColumn
    private List<Image> images;

    @Column(nullable = false)
    private float price;

    @CreatedDate
    private Instant createdAt = Instant.now();
}
