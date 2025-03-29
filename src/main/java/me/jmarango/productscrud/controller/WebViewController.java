package me.jmarango.productscrud.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class WebViewController {

    @GetMapping()
    public String index() {
        return "index";
    }

}
