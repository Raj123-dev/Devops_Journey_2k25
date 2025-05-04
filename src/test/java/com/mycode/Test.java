package com.mycode;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertEquals;

public class AppTest {

    @Test
    public void testGetMessage() {
        App app = new App();
        String message = app.getMessage();
        assertEquals("Hello, World!", message);
    }
}

