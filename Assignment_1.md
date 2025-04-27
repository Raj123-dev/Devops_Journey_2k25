🚀 Assignment: Setup HelloWorld Simple Jenkins CI-CD on Local Setup (using AWS)
For this task, I decided to use AWS to simulate a local Jenkins CI-CD setup. Here’s how I went about it:
 
🔧 Step 1: Launching an EC2 Instance
Logged into AWS Console.
Searched for EC2 service and clicked on "Launch Instance".
Gave the instance a name: jenkins.
Selected the OS image:
Ubuntu Server 24.04 LTS (HVM), SSD Volume Type
✅ Made sure it's within the Free Tier eligibility.
For the instance type:
Chose t2.micro (free tier eligible).
Since I didn’t have an existing key pair:
Created a new one named jenkins-key.
Chose RSA encryption and .pem format.
Downloaded and safely stored the file: jenkins-key.pem.
Updated Network Settings:
✅ Allowed HTTP traffic from the internet.
✅ Allowed HTTPS traffic from the internet.
Finally, I clicked "Launch Instance", and the EC2 instance was up and running. ✅
 
🧰 Step 2: Connect to the EC2 Instance & Install Jenkins
Once my Jenkins EC2 instance was running, here’s what I did next:
 
🔌 Connecting to the Instance
Waited for a few seconds until the instance showed up as Running.
 
Went to the Instances section, selected the checkbox for the jenkins instance.
 
Clicked “Connect”.
 
Chose EC2 Instance Connect (browser-based terminal).
 
(I could’ve used the .pem key and connected via SSH client, but for simplicity, stuck to AWS browser terminal.)
This opened a terminal with my Ubuntu instance prompt:
 
ubuntu@ip-172-31-92-235:~$
⚙️ Installing Jenkins
First, updated the package lists:
 
sudo apt update
Then, visited: https://pkg.jenkins.io/
 
From there, under Debian Stable, followed the steps to add Jenkins repo:
 
Added the Jenkins GPG key:
 
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
Added the Jenkins apt repository:
 
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian-stable binary/" | sudo tee \
/etc/apt/sources.list.d/jenkins.list > /dev/null
Updated local package index again:
 
sudo apt-get update
Installed Java runtime (required by Jenkins):
 
sudo apt-get install fontconfig openjdk-17-jre
Finally, installed Jenkins itself:
 
sudo apt-get install jenkins
✅ Jenkins was successfully installed at this point.
 
🔄 Step 3: Start Jenkins & Open Jenkins Web UI
With Jenkins installed, it was time to get it running and accessible from the browser.
 
🟢 Starting Jenkins
I ran the following commands:
 
sudo systemctl start jenkins
sudo systemctl enable jenkins
start: This immediately starts the Jenkins service.
enable: This ensures Jenkins will automatically start on boot—so even if I restart the machine, Jenkins starts up again.
The output was:
 
Synchronizing state of jenkins.service with SysV service script with /usr/lib/systemd/systemd-sysv-install.
Executing: /usr/lib/systemd/systemd-sysv-install enable jenkins
 
📋 Checking Jenkins Status
To confirm Jenkins was running properly:
 
sudo systemctl status jenkins
And I got the following output (simplified):
 
● jenkins.service - Jenkins Continuous Integration Server
     Active: active (running) since Thu 2025-04-24
     Main PID: 4282 (java)
 
✅ Jenkins was up and running successfully!
 
🌐 Step 4: Accessing Jenkins from the Browser
Kept the EC2 terminal tab open.
 
Went back to the Instances section in AWS.
 
Checked the Public IPv4 address of the Jenkins instance — mine was:
 
54.210.172.29
 
Tried opening http://54.210.172.29:8080 in a new browser tab...
 
❌ But it didn’t connect. Even though Jenkins runs on port 8080, something was blocking access.
 
🔐 Fixing the Access Issue – Security Group Inbound Rule
To solve this:
 
Went back to the Instances page.
 
Clicked on the Security tab for the instance.
 
Under Security Groups, clicked the group link:
 
sg-0ab7c6faf9b04e132
 
Clicked Edit Inbound Rules.
 
Added a new rule:
 
Type: Custom TCP
Port: 8080
Source: 0.0.0.0/0 (allows access from anywhere)
Clicked Save rules.
 
Now, I reloaded http://54.210.172.29:8080 in my browser...
 
✅ Boom! The Jenkins initial setup screen appeared!
 
I was in 🎉
 
🔑 Step 5: Unlock Jenkins with Admin Password
To get past the Jenkins unlock screen, it asks for the initial admin password stored in a file.
 
So back in the EC2 browser terminal, I ran:
 
cat /var/lib/jenkins/secrets/initialAdminPassword
🚫 But oops — Permission denied.
 
Then I ran it with sudo:
 
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
Got the output:
 
ff4fc1f2982f48f4b77425fec72fa1dc
 
🔓 Entered this on the Jenkins web setup screen to unlock it.
 
🧩 Step 6: Plugin Installation
Jenkins now asked me:
 
What plugins do you want to install?
 
I selected “Install suggested plugins” – safe and quick.
It started installing default essentials like:
Git
Gradle
Pipeline
Ant, etc.
After a few minutes — ✅ All installed successfully.
 
👤 Step 7: Creating the First Admin User
Next up: Jenkins asked me to create an admin account.
 
Here’s what I entered:
 
Username: rohannag
Password: 1234
Confirm Password: 1234
Full Name: Rohan Nag
Email: nagrohan579@gmail.com
Yeah, I know the password isn’t great 😅 but it's just local testing.
 
🌐 Step 8: Instance Configuration
Then Jenkins asked for the instance URL:
 
Jenkins URL: http://54.210.172.29:8080/
 
It auto-filled based on the current access.
Explained that it’s important for things like:
Email notifications
Pull request status updates
BUILD_URL env var in pipelines
Clicked ✅ Save and Finish.
 
🎉 Final Step: Jenkins is Ready!
Got the confirmation:
 
✅ Jenkins is ready!
 
🎈 Your Jenkins setup is complete.
 
Clicked Start using Jenkins — and boom!
 
The Jenkins dashboard opened up in all its glory.
 
🚀 Starting the Jenkins "Hello World" CI/CD Project
With Jenkins up and running, I began setting up my first test project — just to get the basics right.
 
🆕 Step 1: Create a New Project
From the Jenkins Dashboard, I clicked on “New Item.”
 
If Jenkins asked for login credentials again, I just entered:
 
Username: rohannag
Password: 1234
For the Item Name, I typed:
 
hello-world
 
Jenkins gave multiple options:
 
Freestyle project ✅ (I selected this one for simplicity)
Pipeline
Multi-configuration
Folder
etc.
🧩 Step 2: Understanding the Project Options
Here’s a quick breakdown of the project configuration options:
 
Discard old builds: Helps manage storage by automatically deleting older builds after a set number or days.
GitHub project: If checked, lets me link a GitHub repo URL for integration.
This project is parameterized: Allows passing user-defined parameters (e.g., environment name, version) into the build.
Throttle builds: Controls how many builds can run concurrently (across projects or inside one).
Execute concurrent builds if necessary: Enables parallel execution of builds of the same job (useful for high-demand automation).
For now, I didn’t touch any of these.
 
⏰ Step 3: Build Triggers
These define when Jenkins should automatically start a build. Options included:
 
Trigger builds remotely: Allows using a URL or script to trigger builds (e.g., from webhook or curl).
Build after other projects are built: Creates dependency chains between projects.
Build periodically: Like a cron job. E.g., H 0 * * * to build every night.
GitHub hook trigger for GITScm polling: Starts a build when GitHub sends a webhook.
Poll SCM: Jenkins regularly checks for code changes in the source repo.
Since this is just a “Hello World” test, I didn’t configure any triggers.
 
🔧 Step 4: Add Build Step
Under the Build section:
 
I clicked “Add build step” > Execute shell (since my Jenkins is on Ubuntu).
 
In the command box, I simply added:
 
echo "Hello World!"
📝 I could’ve added multiple build steps here for more complex pipelines — like building code, running tests, deploying, etc. But for now, this single echo command is enough.
 
📦 Step 5: Post-build Actions (optional)
There were post-build options like:
 
Archive the artifacts (save files after build)
Send email notifications
Publish test results
Trigger other builds
But again, not required for this small test.
 
💾 Step 6: Save and Run the Build
Hit Save.
On the project dashboard, clicked “Build Now.”
It started building!
 
📜 Step 7: View Console Output
After the build completed, I clicked on:
 
Build #1 > Console Output
Here’s what I saw:
 
Started by user Rohan Nag
Running as SYSTEM
Building in workspace /var/lib/jenkins/workspace/hello-world
[hello-world] $ /bin/sh -xe /tmp/jenkins7653354901156340797.sh
+ echo Hello World!
Hello World!
Finished: SUCCESS
 
🔍 Explanation:
 
Jenkins started the job (Started by user Rohan Nag)
It ran the job as the SYSTEM user
It executed the shell script it generated temporarily
The + echo Hello World! line is our build step being executed
And finally — Hello World! was printed on the terminal
✅ Finished: SUCCESS confirms the build was successful!
🎉 DONE!
My first Jenkins job worked exactly as expected. Simple, clean, and successful.
