package com.example.spring.service;

import com.example.spring.model.User;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.Arrays;
import java.util.List;

@Service
public class UserService {
    private final String API_URL = "https://jsonplaceholder.typicode.com/users";

    public List<User> fetchUsers() {
        RestTemplate restTemplate = new RestTemplate();
        User[] users = restTemplate.getForObject(API_URL, User[].class);
        return Arrays.asList(users);
    }
}