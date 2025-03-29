CREATE SCHEMA products_crud;

CREATE TABLE products_crud.images (
                                      id          BINARY(16)   NOT NULL,
                                      product_id  BIGINT       NULL,

                                      CONSTRAINT pk_images PRIMARY KEY (id)
);

CREATE TABLE products_crud.users (
                                     id       BIGINT         AUTO_INCREMENT NOT NULL,
                                     password VARCHAR(255)   NOT NULL,
                                     role     ENUM('ADMIN', 'USER') NOT NULL,
                                     username VARCHAR(255)   NOT NULL,

                                     CONSTRAINT pk_users PRIMARY KEY (id),
                                     CONSTRAINT uk_users_username UNIQUE (username)
);

CREATE TABLE products_crud.products (
                                        id            BIGINT         AUTO_INCREMENT NOT NULL,
                                        created_at    DATETIME(6)    NULL,
                                        description   VARCHAR(255)   NOT NULL,
                                        name          VARCHAR(255)   NOT NULL,
                                        price         FLOAT          NOT NULL,
                                        author_id     BIGINT         NOT NULL,
                                        image_id      BINARY(16)     NOT NULL,

                                        CONSTRAINT pk_products PRIMARY KEY (id),
                                        CONSTRAINT uk_products_image UNIQUE (image_id),
                                        CONSTRAINT fk_products_image FOREIGN KEY (image_id) REFERENCES products_crud.images (id),
                                        CONSTRAINT fk_products_author FOREIGN KEY (author_id) REFERENCES products_crud.users (id)
);

ALTER TABLE products_crud.images
    ADD CONSTRAINT fk_images_product
        FOREIGN KEY (product_id) REFERENCES products_crud.products (id);