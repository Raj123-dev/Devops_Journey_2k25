### 🚀 Assignment: Setup HelloWorld Simple Jenkins CI-CD on Local Setup (using AWS)

For this task, I decided to use AWS to simulate a local Jenkins CI-CD setup. Here’s how I went about it:

### 🔧 Step 1: Launching an EC2 Instance

1. **Logged into AWS Console**.
2. Searched for **EC2** service and clicked on **"Launch Instance"**.
3. Gave the instance a name: **`first_ec2_machine`**.
4. Selected the OS image:
    - **Ubuntu Server 24.04 LTS (HVM), SSD Volume Type**
    - ✅ Made sure it's within the **Free Tier** eligibility.
5. For the instance type:
    - Chose **`t2.micro`** (free tier eligible).
6. Since I didn’t have an existing key pair:
    - Created a new one named **`ec2_machine-pem`**.
    - Chose **RSA encryption** and **.pem format**.
    - Downloaded and safely stored the file: **`ec2_machine-pem.pem`**.
7. Updated **Network Settings**:
    - ✅ Allowed **HTTP** traffic from the internet.
    - ✅ Allowed **HTTPS** traffic from the internet.

Finally, I clicked **"Launch Instance"**, and the EC2 instance was up and running. ✅

---

### 🧰 Step 2: Connect to the EC2 Instance & Install Jenkins

Once my **first_ec2_machine EC2 instance** was running, here’s what I did next:

### 🔌 Connecting to the Instance

1. Waited for a few seconds until the instance showed up as **Running**.
2. Went to the **Instances** section, selected the checkbox for the `first_ec2_machine` instance.
3. Clicked **“Connect”**.
4. Chose **EC2 Instance Connect** (browser-based terminal).
    - (I could’ve used the `.pem` key and connected via SSH client, but for simplicity, stuck to AWS browser terminal.)
5. This opened a terminal with my Ubuntu instance prompt:
    
    ```bash
    ubuntu@ip-172-31-92-235:~$
    
    ```
    

### ⚙️ Installing Jenkins

1. First, updated the package lists:
    
    ```bash
    sudo apt update
    
    ```
    
2. Then, visited: https://pkg.jenkins.io/
3. From there, under **Debian Stable**, followed the steps to add Jenkins repo:
    - Added the Jenkins GPG key:
        
        ```bash
        sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
        https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
        
        ```
        
    - Added the Jenkins apt repository:
        
        ```bash
        echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
        https://pkg.jenkins.io/debian-stable binary/" | sudo tee \
        /etc/apt/sources.list.d/jenkins.list > /dev/null
        
        ```
        
4. Updated local package index again:
    
    ```bash
    sudo apt-get update
    
    ```
    
5. Installed Java runtime (required by Jenkins):
    
    ```bash
    sudo apt-get install fontconfig openjdk-17-jre
    
    ```
    
6. Finally, installed Jenkins itself:
    
    ```bash
    sudo apt-get install jenkins
    
    ```
    

✅ Jenkins was successfully installed at this point.

---

### 🔄 Step 3: Start Jenkins & Open Jenkins Web UI

With Jenkins installed, it was time to get it running and accessible from the browser.

### 🟢 Starting Jenkins

I ran the following commands:

```bash
sudo systemctl start jenkins
sudo systemctl enable jenkins

```

- `start`: This immediately starts the Jenkins service.
- `enable`: This ensures Jenkins will **automatically start on boot**—so even if I restart the machine, Jenkins starts up again.

The output was:

```
Synchronizing state of jenkins.service with SysV service script with /usr/lib/systemd/systemd-sysv-install.
Executing: /usr/lib/systemd/systemd-sysv-install enable jenkins

```

### 📋 Checking Jenkins Status

To confirm Jenkins was running properly:

```bash
sudo systemctl status jenkins

```

And I got the following output (simplified):

```
● jenkins.service - Jenkins Continuous Integration Server
     Active: active (running) since Thu 2025-04-24
     Main PID: 4282 (java)

```

✅ Jenkins was up and running successfully!

---

### 🌐 Step 4: Accessing Jenkins from the Browser

1. Kept the EC2 terminal tab open.
2. Went back to the **Instances** section in AWS.
3. Checked the **Public IPv4 address** of the Jenkins instance — mine was:
    
    ```
    54.210.172.29
    
    ```
    
4. Tried opening `http://54.210.172.29:8080` in a new browser tab...
    
    ❌ But it **didn’t connect**. Even though Jenkins runs on port `8080`, something was blocking access.
    

### 🔐 Fixing the Access Issue – Security Group Inbound Rule

To solve this:

1. Went back to the **Instances** page.
2. Clicked on the **Security** tab for the instance.
3. Under **Security Groups**, clicked the group link:
    
    `sg-0ab7c6faf9b04e132`
    
4. Clicked **Edit Inbound Rules**.
5. Added a new rule:
    - **Type**: Custom TCP
    - **Port**: `8080`
    - **Source**: `0.0.0.0/0` (allows access from anywhere)
6. Clicked **Save rules**.

Now, I reloaded `http://54.210.172.29:8080` in my browser...

✅ **Boom!** The Jenkins **initial setup screen** appeared!

I was in 🎉

---

### 🔑 Step 5: Unlock Jenkins with Admin Password

To get past the Jenkins unlock screen, it asks for the initial admin password stored in a file.

So back in the **EC2 browser terminal**, I ran:

```bash
cat /var/lib/jenkins/secrets/initialAdminPassword

```

🚫 But oops — *Permission denied*.

Then I ran it with `sudo`:

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

```

Got the output:

```
ff4fc1f2982f48f4b77425fec72fa1dc

```

🔓 Entered this on the Jenkins web setup screen to unlock it.

---

### 🧩 Step 6: Plugin Installation

Jenkins now asked me:

> What plugins do you want to install?
> 
- I selected **“Install suggested plugins”** – safe and quick.
- It started installing default essentials like:
    - **Git**
    - **Gradle**
    - **Pipeline**
    - **Ant**, etc.

After a few minutes — ✅ All installed successfully.

---

### 👤 Step 7: Creating the First Admin User

Next up: Jenkins asked me to create an admin account.

Here’s what I entered:

- **Username**: `RajKashyap`
- **Password**: `788011`
- **Confirm Password**: `788011`
- **Full Name**: `Raj Kashyap`
- **Email**: `rajdeveloper1234@gmail.com`

Yeah, I know the password isn’t great 😅 but it's just local testing.

---

### 🌐 Step 8: Instance Configuration

Then Jenkins asked for the instance URL:

```
Jenkins URL: http://54.210.172.29:8080/

```

- It auto-filled based on the current access.
- Explained that it’s important for things like:
    - Email notifications
    - Pull request status updates
    - `BUILD_URL` env var in pipelines

Clicked ✅ **Save and Finish**.

---

### 🎉 Final Step: Jenkins is Ready!

Got the confirmation:

> ✅ Jenkins is ready!
> 
> 
> 🎈 Your Jenkins setup is complete.
> 

Clicked **Start using Jenkins** — and boom!

The **Jenkins dashboard** opened up in all its glory.

---

### 🧪 Step 9: Jenkinsfile Created on GitHub & CI/CD Pipeline Setup
After successfully setting up Jenkins, I created a simple Jenkinsfile in my GitHub repository to test the CI/CD pipeline.

🔹 Jenkinsfile Content
Here’s the content of the Jenkinsfile I added to the root of my GitHub repository:

groovy
Copy
Edit
pipeline {
    agent any

    stages {
        stage('Hello World') {
            steps {
                echo 'Hello, World from Jenkins!'
            }
        }
    }
}
🔹 GitHub Repository
The Jenkinsfile is located in this GitHub repo:
🔗 https://github.com/your-username/your-repo-name
(Replace with your actual repo link)

🔹 CI/CD Pipeline Setup in Jenkins
To connect Jenkins with the GitHub repo:

Opened Jenkins dashboard → Clicked "New Item"

Selected Pipeline → Named it hello-world-pipeline

Chose "Pipeline script from SCM"

Selected:

SCM: Git

Repository URL: https://github.com/your-username/your-repo-name.git

(If private repo: added GitHub credentials)

Set the branch to main (or whichever branch contains the Jenkinsfile)

Clicked Save and then "Build Now"

✅ Pipeline Output
The build was triggered, and in the Jenkins console log, I saw:

csharp
Copy
Edit
[Pipeline] Start of Pipeline
[Pipeline] echo
Hello, World from Jenkins!
[Pipeline] End of Pipeline
🎉 Boom! Jenkins successfully cloned the repo, read the Jenkinsfile, and executed it.


