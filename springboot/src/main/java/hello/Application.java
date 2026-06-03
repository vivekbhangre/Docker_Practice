package hello;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public class Application {

    @RequestMapping("/api/health")
    public String healthCheck() {
        // Returns a clean JSON string for our new frontend dashboard to fetch and parse
        return "{\"status\":\"ACTIVE\", \"runtime\":\"Java 17\", \"engine\":\"Docker Container\"}";
    }

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
