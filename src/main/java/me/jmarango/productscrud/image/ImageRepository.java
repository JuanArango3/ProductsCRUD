package me.jmarango.productscrud.image;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.time.Instant;
import java.util.Set;
import java.util.UUID;

public interface ImageRepository extends JpaRepository<Image, UUID> {
    @Query("select i from Image i where i.product is not null and i.dateUploaded > ?1")
    Set<Image> findImagesByUploadedAfter(Instant date);
}