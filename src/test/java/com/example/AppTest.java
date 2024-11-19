package com.example;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;
import com.example.App;  // Correct import statement

public class AppTest {

    @Test
    public void testHello() {
        App app = new App();  // This will now correctly reference App from com.example
        String result = app.hello();
        assertEquals("Welcome, Swati Banking Microservice!", result);
    }
}
