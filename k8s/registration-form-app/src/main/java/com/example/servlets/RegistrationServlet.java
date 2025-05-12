package com.example.servlets;

import com.example.utils.DatabaseConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/register")
public class RegistrationServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (validateInput(name, email, password)) {
            try {
                DatabaseConnection dbConnection = new DatabaseConnection();
                Connection connection = dbConnection.getConnection();
                String sql = "INSERT INTO users (name, email, password) VALUES (?, ?, ?)";
                PreparedStatement statement = connection.prepareStatement(sql);
                statement.setString(1, name);
                statement.setString(2, email);
                statement.setString(3, password);
                statement.executeUpdate();
                connection.close();
                response.sendRedirect("registration-success.html");
            } catch (SQLException e) {
                e.printStackTrace();
                response.sendRedirect("registration-error.html");
            }
        } else {
            response.sendRedirect("registration-error.html");
        }
    }

    private boolean validateInput(String name, String email, String password) {
        return name != null && !name.isEmpty() && email != null && !email.isEmpty() && password != null && !password.isEmpty();
    }
}