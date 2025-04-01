
## SetUp Jenkins for Ubuntu

### Prerequisite 
- Installation of Java
```sh
sudo apt update

sudo apt install fontconfig openjdk-17-jre

java -version
```

### Installation of Jenkins
- Add Jenkins key and repository
- Update package list
- Install Jenkins

```sh
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update

sudo apt-get install jenkins
```

### NOTE: 
- Beginning with Jenkins 2.335 and Jenkins 2.332.1, the package is configured with systemd rather than the older System V init. More information is available in "Managing systemd services".
- The package installation will:
    1. Setup Jenkins as a daemon launched on start. Run `systemctl cat jenkins` for more details.
    2. Create a ‘jenkins’ user to run this service.
    3. Direct console log output to systemd-journald. Run `journalctl -u jenkins.service` if you are troubleshooting Jenkins.
    4. Populate `/lib/systemd/system/jenkins.service` with configuration parameters for the launch, e.g `JENKINS_HOME`
    5. Set Jenkins to listen on port 8080. Access this port with your browser to start configuration.
- If Jenkins fails to start because a port is in use, run `systemctl edit jenkins` and add the following:
    ```yaml
    [Service]
    Environment="JENKINS_PORT=8081"
    ```
    Here, "8081" was chosen but you can put another port available.

### Start Jenkins
- `sudo systemctl start jenkins`
- `sudo systemctl status jenkins`
- `sudo systemctl enable jenkins`

### Post-installation setup wizard
- Browse to http://localhost:8080
- Retrieve initial admin password: `sudo cat /var/lib/jenkins/secrets/initialAdminPassword`