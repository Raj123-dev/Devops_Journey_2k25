package com.mycode;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertEquals;

public class TestApp {

    @Test
    public void testGetMessage() {
        HelloWorld app = new HelloWorld();
        String message = app.getMessage();
        assertEquals("Hello, World!", message);
    }
}

