package com.khubeev.controller;

import com.khubeev.dto.CreateUserRequest;
import com.khubeev.service.JpaUserService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/forms")
public class FormController {

    private final JpaUserService jpaUserService;

    public FormController(JpaUserService jpaUserService) {
        this.jpaUserService = jpaUserService;
    }

    @PostMapping("/register")
    public String registerForm(CreateUserRequest request, RedirectAttributes redirectAttributes) {
        try {
            jpaUserService.createUser(request.getUsername(), request.getPassword());
            return "redirect:/login?registered";
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/register";
        }
    }
}