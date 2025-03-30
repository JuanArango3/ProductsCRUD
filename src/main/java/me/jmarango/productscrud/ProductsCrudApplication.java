package me.jmarango.productscrud;

import me.jmarango.security.annotations.EnableAuthentication;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.transaction.annotation.EnableTransactionManagement;

@SpringBootApplication
@EnableAuthentication
@EnableTransactionManagement
public class ProductsCrudApplication {

    public static void main(String[] args) {
        SpringApplication.run(ProductsCrudApplication.class, args);
    }

}
