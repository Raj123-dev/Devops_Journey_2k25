package com.mycode;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertEquals;

public class Test {

    @Test
    public void testGetMessage() {
        HeloWorld app = new HelloWorld();
        String message = app.getMessage();
        assertEquals("Hello, World!", message);
    }
}

