## 🛠️ Description of Shell Scripts
- **apache.sh**: Installs Apache 2.4.49. This process usually takes about 20-30 minutes.
- **webcam.sh**: Sets up the necessary configurations for the application's execution and copies resources like HTML, CSS, JavaScript, and CGI programs.
- **client-setup.sh**: Connects to the server and downloads configuration files.

## 🚀 Setup Instructions
Execute the following scripts in order:
   ```sh
   sudo sh apache.sh
   sudo sh webcam.sh
   sudo bash client-setup.sh SERVER_IP_ADDR