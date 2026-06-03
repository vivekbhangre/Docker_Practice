# Docker Practice Hub: Multi-Stack Deployment on AWS EC2

Welcome to my DevOps practice portfolio! This monorepo showcases the manual containerization and cloud deployment of four distinct web applications built using completely different technology stacks. 

Instead of relying on automated orchestration tools like Docker Compose, this project focuses on mastering core **Docker CLI operations**, writing **highly optimized multi-stage Dockerfiles**, serving frontend assets natively through a backend engine, and managing **independent container networking** directly on an Amazon Linux cloud server.

---

## 📁 Repository Structure

```text
Docker_Practice/
├── README.md
├── java/            # Traditional JSP/Servlet Web App (Tomcat)
├── pythonflash/     # Lightweight Python Flask App
├── springboot/      # Full-Stack Java Spring Boot Web App & DevOps Dashboard
└── reactjs/         # Frontend React.js Application (Nginx)
```

---

## 📦 Project Stacks & Deployment Matrix

| Project Directory | Tech Stack | Internal Container Port | Target Host (EC2) Port | Production Strategy |
| :--- | :--- | :--- | :--- | :--- |
| **`pythonflash`** | Python 3.9, Flask | `5000` | `5000` | Single-stage, public network binding via `--host=0.0.0.0` |
| **`reactjs`** | React.js, Node.js, Nginx | `80` | `80` | Multi-stage build compiled into static assets served via Nginx |
| **`springboot`** | Java 17, Spring Boot, Tailwind CSS | `8080` | `8080` | Multi-stage build serving an embedded static HTML dashboard at `/` and REST API at `/api/health` |
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

### 3. Python Flask App (`/pythonflash/Dockerfile`)
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
* **Port 8080** (Java Spring Boot Web App)
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

# Grant user group permissions to run Docker commands without sudo
sudo usermod -aG docker $USER
```
> ⚠️ **Note:** If you are running commands as the `root` user directly, group modification is optional, but recommended for standard deployment workflows. Re-log or refresh your terminal session to apply group changes.

### 3. Clone the Project
```bash
git clone https://github.com/vivekbhangre/Docker_Practice.git
cd Docker_Practice
```

### 4. Build and Run the Applications Manually

Execute the following commands from the root of the `Docker_Practice` directory to compile the multi-stage builds and launch the containers detached (`-d`) in the background:

#### ☕ Traditional Java Web Application
```bash
docker build -t traditional-image ./java
docker run -d -p 8081:8080 --name traditional-container traditional-image
```

#### 🍃 Java Spring Boot Application
```bash
docker build -t simple-boot-image ./springboot
docker run -d -p 8080:8080 --name simple-boot-container simple-boot-image
```

#### 🐍 Python Flask Application
```bash
docker build -t flask-image ./pythonflash
docker run -d -p 5000:5000 --name python-container flask-image
```

#### ⚛️ React.js Frontend Application
```bash
docker build -t react-image ./reactjs
docker run -d -p 80:80 --name react-container react-image
```

---

## 🧠 Key Learnings from this Project

* **Multi-Stage Build Optimization:** Understood how to separate the heavy compilation dependencies (Maven/Node SDKs) from the final runtime images. This resulted in drastically smaller image sizes and vastly faster cloud deployments.
* **Embedded Static Asset Routing:** Discovered how Spring Boot's internal web architecture mapping handles static content. By positioning frontend code within the `src/main/resources/static/` directory and re-routing competing Java mappings, a single container can flawlessly serve a rich user interface alongside an active REST API.
* **Monorepo Structure & Build Context:** Learned how to manage distinct application contexts within a single code repository, pointing Docker build executions to isolated sub-folders seamlessly.

---

## 🔍 Common Errors & Troubleshooting Solutions

### 1. "Port Already in Use" Errors
* **Cause:** Trying to spin up two containers mapped to the same host port (e.g., trying to map multiple frameworks onto port `8080`).
* **Fix:** Ensure each manual `docker run` statement maps to a distinct host port (e.g., `-p 8080:8080` vs `-p 8081:8080`).

### 2. Out of Memory (OOM) Errors During Build
* **Cause:** Compiling heavy Java applications and React builds concurrently can exhaust the 1GB RAM limits of an AWS `t2.micro` free-tier instance.
* **Fix:** Build the applications sequentially rather than concurrently, or allocate a small virtual swap file space inside Amazon Linux to assist the memory pool.

### 3. Static Assets Not Rendering / 404 Whitelabel
* **Cause:** A controller mapping (such as `@RequestMapping("/")`) blocking Spring Boot's automatic lookups within the static resources block.
* **Fix:** Shift background Java controller endpoints to specific API sub-routes (like `/api/health`) to allow your frontend `index.html` full control over the root context path.

---

## 📸 Screenshots

To verify that all four application stacks are successfully containerized, isolated, and serving live traffic from the AWS EC2 cloud instance, see the deployment verification details below:

### 1. ☕ Traditional Java Web Application (Port 8081)
<img width="958" height="1079" alt="building_docker_image_for_java" src="https://github.com/user-attachments/assets/de697705-5298-4853-9e87-8c22d863d1e3" />
<img width="959" height="68" alt="building_docker_image_for_java_1" src="https://github.com/user-attachments/assets/2cdc94ad-99c0-47dc-b9a4-e4829d76aa2b" />
<img width="958" height="123" alt="after_image_built" src="https://github.com/user-attachments/assets/2033f253-fcc6-4a9d-81fe-a690fd1534cf" />
<img width="957" height="166" alt="running_image" src="https://github.com/user-attachments/assets/7e0a91e4-2e66-49e5-be9a-7430de009939" />
<img width="1919" height="1079" alt="accessing-java-based-web" src="https://github.com/user-attachments/assets/f6bf3f9c-2eb0-41ff-a070-56acd9de5e89" />
*Status: Independent Apache Tomcat server hosting the dynamic JSP/Servlet application archive on mapped port 8081.*

### 2. 🍃 Java Spring Boot Application (Port 8080)
<img width="956" height="952" alt="building_docker_image_for_java_spring_boot" src="https://github.com/user-attachments/assets/dd8039e1-c1f1-4aa5-be26-08360e897abc" />
<img width="957" height="194" alt="running_image_spring_boot" src="https://github.com/user-attachments/assets/e8cfc98c-5caf-497a-ac0c-f17aa1c3649c" />
<img width="1919" height="1079" alt="accessing-java-spring-boot" src="https://github.com/user-attachments/assets/e4602fa6-90b2-40e2-b4ea-9db11f5cbbef" />
*Status: Full-stack dark-mode DevOps Control Matrix UI rendering dynamically at port 8080 with interactive fetch requests running back into the Java runtime.*

### 3. 🐍 Python Flask Backend Application (Port 5000)
<img width="958" height="710" alt="building_running_python_flask_image" src="https://github.com/user-attachments/assets/3fd37c68-df6d-4ccd-9ac0-97d624d4597a" />
<img width="1919" height="1079" alt="accessing_python_flash" src="https://github.com/user-attachments/assets/55cd004b-0ecc-4c2f-8e8b-40dd690fd032" />
*Status: Lightweight Python web server actively handling live browser requests on port 5000.*

### 4. ⚛️ React.js Frontend Application (Port 80)
<img width="956" height="758" alt="building_running_docker_image_for_reactjs" src="https://github.com/user-attachments/assets/8b087299-e417-4671-be6e-aa01bbb332f9" />
<img width="1919" height="1079" alt="accessing-reactjs_web" src="https://github.com/user-attachments/assets/658fb7ab-4ef3-40b2-b047-2656b33cc2ad" />

*Status: Live frontend web UI rendering the interactive application directly over standard HTTP.*

---

---

## 🛠️ DevOps Monitoring & Maintenance Cheat Sheet

Use these vital commands to manage your detached cloud containers:

* **View Dashboard of All Running Containers:**
    ```bash
    docker ps
    ```
* **Inspect Live Application Logs (Highly useful for debugging crashes):**
    ```bash
    docker logs -f <container-name>
    ```
* **Stop a Container Safely:**
    ```bash
    docker stop <container-name>
    ```
* **Remove a Container to Rebuild:**
    ```bash
    docker rm <container-name>
    ```
* **Clean Up Unused Cache and System Bloat:**
    ```bash
    docker system prune -a --volumes
    ```

## 🔮 Future Implementations

To evolve this monorepo from a manual cloud sandbox into an enterprise-grade, resilient production infrastructure, the following scaling phases are planned:

### 🚀 Phase 1: Infrastructure Automation & CI/CD Pipelines
* **GitHub Actions Workflows:** Implement automated CI/CD pipelines so that any commit pushed to the `main` branch automatically triggers multi-stage testing, builds the optimized images, and pushes them straight to **Amazon ECR (Elastic Container Registry)**.
* **Automated Webhook Deployment:** Configure a lightweight CD continuous deployment daemon on the EC2 instance to listen for successful image pushes, pull the fresh images, and recreate the runtime containers completely hands-free.

### 🔒 Phase 2: Centralized Ingress Routing & SSL Security
* **Centralized Nginx Reverse Proxy:** Remove the practice of exposing raw application ports (5000, 8080, 8081) directly to the public internet. Instead, run a single Nginx reverse proxy on port 80/443 to route traffic based on path domains (e.g., `/flask`, `/springboot`).
* **Automated SSL Encryption:** Integrate **Certbot / Let's Encrypt** inside the Ingress gateway layer to provision and auto-renew TLS/SSL certificates, forcing all framework traffic over secure HTTPS protocol pathways.

### ☸️ Phase 3: Orchestration & Infrastructure as Code (IaC)
* **Multi-Container Composition:** Write a declarative, unified `docker-compose.yml` file to define cross-stack environment variables, persistent volumes, and explicit startup sequencing dependencies in one command.
* **Kubernetes Migration (AWS EKS):** Transition the standalone container matrix into an **Amazon EKS Cluster** to leverage industry-grade cluster orchestration, horizontal pod auto-scaling, load balancing, and self-healing node replicas.
* **Terraform Blueprints:** Convert the manual AWS cloud provisioning steps into declarative code using **Terraform** to spin up the EC2 instances, subnets, and security groups deterministically.

### 📊 Phase 4: Enterprise Observability & Telemetry Stack
* **Centralized Logging:** Deploy an aggregated logging framework (such as the ELK stack or Grafana Loki) to capture and search `stdout` terminal output streams from all isolated containers in a single console grid.
* **Metrics Monitoring:** Integrate **Prometheus** to scrape system utilization data alongside a **Grafana Dashboard** to visualize CPU, memory consumption spikes, and HTTP request metrics in real time.

