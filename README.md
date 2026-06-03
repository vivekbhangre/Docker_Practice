# Docker Practice Hub: Multi-Stack Deployment on AWS EC2

Welcome to my DevOps practice portfolio! This monorepo showcases the manual containerization and cloud deployment of four distinct web applications built using completely different technology stacks. 

Instead of relying on automated orchestration tools like Docker Compose, this project focuses on mastering core **Docker CLI operations**, writing **highly optimized multi-stage Dockerfiles**, and managing **independent container networking** directly on an Amazon Linux cloud server.

---

## 📁 Repository Structure

```text
Docker_Practice/
├── README.md
├── java/            # Traditional JSP/Servlet Web App (Tomcat)
├── python/          # Lightweight Python Flask App
├── springboot/      # Modern Java Spring Boot REST API
└── reactjs/         # Frontend React.js Application (Nginx)
```

---

## 📦 Project Stacks & Deployment Matrix

| Project Directory | Tech Stack | Internal Container Port | Target Host (EC2) Port | Production Strategy |
| :--- | :--- | :--- | :--- | :--- |
| **`python`** | Python 3.9, Flask | `5000` | `5000` | Single-stage, public network binding via `--host=0.0.0.0` |
| **`reactjs`** | React.js, Node.js, Nginx | `80` | `80` | Multi-stage build compiled into static assets served via Nginx |
| **`springboot`** | Java 17, Spring Boot, JRE | `8080` | `8080` | Multi-stage build compiled into an executable fat `.jar` |
| **`java`** | Java 11, Servlet/JSP, Tomcat | `8080` | `8081` | Multi-stage build compiled into `.war` and hosted on standalone Apache Tomcat |

---

## 📄 Dockerfile Configurations

Here are the optimized configurations written for each application stack inside this repository:

### 1. Traditional Java Web App (`/java/Dockerfile`)
```dockerfile
FROM maven:3.8-openjdk-11 AS build
WORKDIR /app
COPY . .
RUN mvn clean package

FROM tomcat:9-jre11-slim
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
```

### 2. Java Spring Boot App (`/springboot/Dockerfile`)
```dockerfile
FROM maven:3.8-openjdk-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

### 3. Python Flask App (`/python/Dockerfile`)
```dockerfile
FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 5000
CMD ["flask", "run", "--host=0.0.0.0"]
```

### 4. React.js App (`/reactjs/Dockerfile`)
```dockerfile
FROM node:18-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
```

---

## 🚀 Step-by-Step AWS EC2 Deployment Guide (Amazon Linux)

### 1. Configure Inbound Security Group Rules on AWS
Before launching the containers, ensure your EC2 instance's Security Group has the following inbound ports open to public traffic (`0.0.0.0/0`):
* **Port 22** (SSH Access)
* **Port 80** (React Frontend)
* **Port 5000** (Python Flask API)
* **Port 8080** (Java Spring Boot App)
* **Port 8081** (Traditional Java Web App)

### 2. Set Up Docker on Amazon Linux EC2
Connect to your EC2 instance via SSH and run the following configuration commands:
```bash
# Update the system package manager
sudo dnf update -y

# Install Docker and Git
sudo dnf install docker git -y

# Start the Docker daemon and enable it to run on system boot
sudo systemctl start docker
sudo systemctl enable docker

# Grant the default ec2-user group permissions to run Docker commands
sudo usermod -aG docker ec2-user
```
> ⚠️ **Important:** Type `exit` to close the connection, then reconnect immediately to refresh your user group permissions. This allows you to run Docker commands without typing `sudo`.

### 3. Clone the Project
```bash
git clone https://github.com/vivekbhangre/Docker_Practice.git
cd Docker_Practice
```

### 4. Build and Run the Applications Manually

Execute the following commands from the root of the `Docker_Practice` directory to compile the multi-stage builds and launch the containers detached (`-d`) in the background:

#### 🐍 Python Flask Application
```bash
docker build -t flask-image ./python
docker run -d -p 5000:5000 --name python-container flask-image
```

#### ⚛️ React.js Frontend Application
```bash
docker build -t react-image ./reactjs
docker run -d -p 80:80 --name react-container react-image
```

#### 🍃 Java Spring Boot Application
```bash
docker build -t boot-image ./springboot
docker run -d -p 8080:8080 --name boot-container boot-image
```

#### ☕ Traditional Java Web Application
```bash
docker build -t traditional-image ./java
docker run -d -p 8081:8080 --name traditional-container traditional-image
```

---

## 🧠 Key Learnings from this Project

* **Multi-Stage Build Optimization:** Understood how to separate the heavy compilation dependencies (Maven/Node SDKs) from the final runtime images. This resulted in drastically smaller image sizes and vastly faster cloud deployments.
* **Port Overlap and Networking:** Learned how Docker isolates container network layers. Since multiple applications used internal port `8080`, I mastered host-to-container port mapping (`-p`) to prevent collisions on the host EC2 instance.
* **Environment Architecture Consistency:** Proved the core thesis of DevOps: "Build once, run anywhere". The exact container definitions built locally executed identically when moved onto an Amazon Linux cloud instance.
* **Caching Strategy:** Discovered how Docker processes build instructions layer-by-layer. Ordering actions by copying configuration files (`package.json`, `requirements.txt`) *prior* to full application code structures saves significant cache-rebuild time.

---

## 🔍 Common Errors & Troubleshooting Solutions

### 1. "Port Already in Use" Errors
* **Cause:** Trying to spin up two containers mapped to the same host port (e.g., trying to give both Java applications port `8080`).
* **Fix:** Ensure each manual `docker run` statement maps to a distinct host port (e.g., `-p 8080:8080` vs `-p 8081:8080`).

### 2. Out of Memory (OOM) Errors During Build
* **Cause:** Compiling heavy Java applications and React builds concurrently can exhaust the 1GB RAM limits of an AWS `t2.micro` free-tier instance.
* **Fix:** Build the applications sequentially rather than concurrently, or allocate a small virtual swap file space inside Amazon Linux to assist the memory pool.

### 3. Localhost Connection Refusal Inside Containers
* **Cause:** Standard single-stage scripts starting services on `127.0.0.1` inside a container. This locks network listening strictly inside that container's internal scope.
* **Fix:** Explicitly pass binding parameters like `--host=0.0.0.0` to force frameworks (like Flask) to listen broadly across the Docker bridging gateway.

---

## 🔮 Future Enhancements & Next Steps

* **Multi-Container Orchestration:** Transition these independent manual `docker run` scripts into a centralized `docker-compose.yml` architecture for streamlined single-command maintenance.
* **Reverse Proxy Integration (Nginx):** Put an Nginx container in front of the ecosystem to act as a reverse proxy, mapping human-readable custom domain pathways to target specific ports transparently.
* **CI/CD Pipeline Automation:** Configure a GitHub Actions workflow to build, run tests, and automatically ship compiled, updated images directly to Docker Hub upon every code push.

---

## 🛠️ DevOps Maintenance Cheat Sheet

* **View Dashboard of All Running Containers:** `docker ps`
* **Inspect Live Application Logs:** `docker logs -f <container-name>`
* **Stop a Container Safely:** `docker stop <container-name>`
* **Remove a Container:** `docker rm <container-name>`
* **Clean Up Unused Cache and System Bloat:** `docker system prune -a --volumes`