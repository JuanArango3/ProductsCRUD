CREATE SCHEMA IF NOT EXISTS products_crud;
USE products_crud;

CREATE TABLE users (
                                     id       BIGINT         AUTO_INCREMENT NOT NULL,
                                     username VARCHAR(255)   NOT NULL,
                                     password VARCHAR(255)   NOT NULL,
                                     role     VARCHAR(255)   NOT NULL,

                                     CONSTRAINT pk_users PRIMARY KEY (id),
                                     CONSTRAINT uk_users_username UNIQUE (username)
);

CREATE TABLE products (
                                        id            BIGINT         AUTO_INCREMENT NOT NULL,
                                        name          VARCHAR(255)   NOT NULL,
                                        description   VARCHAR(255)   NOT NULL,
                                        price         FLOAT          NOT NULL,
                                        created_at    DATETIME(6)    NULL,
                                        author_id     BIGINT         NOT NULL,

                                        CONSTRAINT pk_products PRIMARY KEY (id),
                                        CONSTRAINT fk_products_author FOREIGN KEY (author_id) REFERENCES users (id)
);

CREATE TABLE images (
                                      id            VARCHAR(36)    NOT NULL,
                                      product_id    BIGINT         NULL,
                                      images_order  INT            NULL,
                                      date_uploaded DATETIME(6)    NULL,

                                      CONSTRAINT pk_images PRIMARY KEY (id),
                                      CONSTRAINT fk_images_product FOREIGN KEY (product_id) REFERENCES products (id)
);