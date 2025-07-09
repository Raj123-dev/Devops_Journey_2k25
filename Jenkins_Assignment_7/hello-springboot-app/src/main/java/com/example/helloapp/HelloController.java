package com.example.helloapp;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;

@RestController
public class HelloController {

    @GetMapping("/hi")
    public String sayHello() {
        return "Hi Raj Kashyap!!!!!! That's my Java application.";
    }

    // 🚨 Vulnerable endpoint (for testing CodeQL)
    @GetMapping("/run")
    public String runCommand(@RequestParam String cmd) throws IOException {
        // ⚠️ CodeQL will flag this as a security issue (command injection)
        Runtime.getRuntime().exec(cmd);
        return "Command executed: " + cmd;
    }
}

