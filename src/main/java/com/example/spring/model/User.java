package com.example.spring.model;

import lombok.Data;

@Data
public class User {
    private int id;
    private String name;
    private String username;
    private String email;

    // Getters and Setters (or use @Data from Lombok)
}