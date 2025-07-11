package com.example.helloapp;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@RestController
public class HelloController {

    // Duplicate method
    @GetMapping("/hi")
    public String sayHello() {
        return "Hi Raj Kashyap!!!!!! That's my Java application.";
    }

    // Duplicate logic (code smell)
    @GetMapping("/hello")
    public String sayHelloAgain() {
        return "Hi Raj Kashyap!!!!!! That's my Java application.";
    }

    // Vulnerable endpoint (command injection)
    @GetMapping("/run")
    public String runCommand(@RequestParam String cmd) throws IOException {
        Runtime.getRuntime().exec(cmd);  // Command injection (CodeQL will flag)
        return "Command executed: " + cmd;
    }

    // Useless function (code smell)
    public void doNothing() {
        System.out.println("Doing nothing");
    }

    // Bad naming (code smell), duplication
    public List<String> getDataList() {
        List<String> data = new ArrayList<>();
        data.add("Raj");
        data.add("Kashyap");
        return data;
    }

    public List<String> getDataList2() {
        List<String> data = new ArrayList<>();
        data.add("Raj");
        data.add("Kashyap");
        return data;
    }

    // Magic number (code smell)
    public int calculateDiscount(int price) {
        return price - 50; // hardcoded discount
    }

    // Unused private method
    private void unusedMethod() {
        int x = 10;
        int y = 20;
        int z = x + y;
    }
}
