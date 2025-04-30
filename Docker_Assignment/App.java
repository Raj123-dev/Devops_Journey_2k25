import com.sun.net.httpserver.HttpServer;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpExchange;

import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;

public class App {

    public static void main(String[] args) throws IOException {
        
        HttpServer server = HttpServer.create(new InetSocketAddress(8000), 0);

        
        server.createContext("/", new RootHandler());
        server.createContext("/how-are-you", new HowAreYouHandler());

        
        server.setExecutor(null); 
        server.start();

        System.out.println("Server started at http://localhost:8000/");
    }

    
    static class RootHandler implements HttpHandler {
        public void handle(HttpExchange exchange) throws IOException {
            String response = "It's Raj Welcome to my simple web app!";
            exchange.sendResponseHeaders(200, response.length());
            OutputStream os = exchange.getResponseBody();
            os.write(response.getBytes());
            os.close();
        }
    }

    
    static class HowAreYouHandler implements HttpHandler {
        public void handle(HttpExchange exchange) throws IOException {
            String response = "I'm Fine! How are you?";
            exchange.sendResponseHeaders(200, response.length());
            OutputStream os = exchange.getResponseBody();
            os.write(response.getBytes());
            os.close();
        }
    }
}
