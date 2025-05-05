
# Complete Docker Basics 

---

## 🔹 What is Docker?
Docker is a tool designed to make it easier to **create, deploy, and run applications** by using containers.  
Containers allow a developer to package up an application with all parts it needs (like libraries and other dependencies) and ship it as one package.

---

## 🔹 **Docker Engine**
- Docker Engine ek client-server architecture hai, jo Docker ko run karne ke liye zaroori components provide karta hai.
- Isme do main parts hote hain:
  - **Docker Daemon (dockerd)**: Background process jo containers ko create, manage aur run karta hai.
  - **Docker CLI (Client)**: Command Line Interface jiske through hum Docker commands run karte hain.
- Jab aap `docker run` command dete ho, to ye daemon container run karta hai.

---

## 🔹 Docker Image vs Container
| Term     | Description                             |
|----------|-----------------------------------------|
| Image    | Blueprint/template for container        |
| Container| Running instance of an image            |

> Image = Recipe, Container = Cooked dish

---

## 🔹 Docker Hub
Docker Hub is a **cloud-based registry** to store and share container images.  
Example:
```bash
docker pull nginx
```

---

## 🔹**Docker Compose**
- Docker Compose ek tool hai jisse aap multi-container applications ko define aur run kar sakte ho.
- Aap ek `docker-compose.yml` file banate ho jisme multiple containers ka configuration likhte ho.
- Ek hi command se sab containers ek saath run ho jate hain.
- Example:
```yaml
version: '3'
services:
  web:
    image: nginx
    ports:
      - "80:80"
  db:
    image: mysql
    environment:
      MYSQL_ROOT_PASSWORD: example
```
Command:
```bash
docker-compose up
```


## 🔹 Dockerfile
A Dockerfile is a text document that contains all the commands to build a Docker image.

**Example Dockerfile:**
```Dockerfile
FROM node:16
WORKDIR /app
COPY . .
RUN npm install
CMD ["node", "app.js"]
```

---

## 🔹 CMD vs ENTRYPOINT
| CMD              | ENTRYPOINT         |
|------------------|--------------------|
| Default command  | Always executes    |
| Overridden easily| More strict        |

**Simple Difference**:
- CMD: Suggestion
- ENTRYPOINT: Instruction

---

## 🔹 Docker Volumes
Used for **persistent storage**.  
Example:
```bash
docker run -v mydata:/data nginx
```

---

## 🔹 Docker Networks
Docker networks allow containers to communicate.  
Types:
- bridge (default)
- host
- none
- custom

---

## 🔹 Ports
Expose container service to host system.  
Example:
```bash
docker run -p 8080:80 nginx
```
Means: Host 8080 → Container 80

---

## 🔹 Docker Architecture (Hinglish)
1. Docker CLI → Commands
2. Docker Daemon → Handles commands
3. Container → Runs app
4. Docker Hub → Store images

---

## 🔹 Important Docker Commands
```bash
docker pull <image>           # Download image
docker build -t myapp .       # Build from Dockerfile
docker run -d -p 8080:80 myapp# Run container
docker ps                     # List running containers
docker stop <container_id>    # Stop container
docker rm <container_id>      # Remove container
docker rmi <image_id>         # Remove image
```

---

## 🔹 Jenkins: Freestyle vs Pipeline (Extra)
| Freestyle Project | Pipeline Project        |
|-------------------|-------------------------|
| GUI-based         | Code-based (Jenkinsfile)|
| Less flexible     | More flexible & powerful|
| Easy to setup     | Better for CI/CD        |

---

## ✅ Summary:
- Docker is used to run apps in isolated environments (containers).
- Dockerfile helps build images.
- Compose manages multiple containers.
- CMD/ENTRYPOINT control default behavior.
- Volumes save data.
- Networks help communication.


## 2. **Docker Hub**
- Docker Hub ek cloud-based registry hai jahan Docker images ko store, share aur download kiya ja sakta hai.
- Yahan public aur private repositories dono hoti hain.
- Common images jaise `nginx`, `mysql` yahan easily available hoti hain.
- Example:
```bash
docker pull nginx
```

---

## 🔹 **Docker Architecture**
### Components:
1. **Docker Client** – Commands run karta hai.
2. **Docker Daemon** – Containers ko manage karta hai.
3. **Docker Images** – Application templates hoti hain.
4. **Docker Containers** – Running instances hote hain.
5. **Docker Hub** – Registry jahan images store hoti hain.
6. **Docker Volumes** – Persistent storage ke liye.
7. **Docker Networks** – Containers ke beech communication ke liye.

**Flow**: Client → Daemon → Image → Container → Result


## Summary:
- **Docker Engine** = Core software (Client + Daemon)
- **Docker Hub** = Online image store
- **Docker Compose** = Multi-container management tool

