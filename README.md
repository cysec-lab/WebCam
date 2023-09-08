## 📄 Description of Text Files
- **setting.txt**: Used to set static IP addresses, DNS, and Router. Make sure to modify the values based on your desired settings.
- **target.txt**: Specifies the server to which images will be sent, and also sets the ID and API token for transmission.

## 🛠️ Description of Shell Scripts
- **apache.sh**: Installs apache2.4.49. The process typically takes around 20-30 minutes.
- **network.sh**: Reads from `setting.txt` and applies the configurations.
- **webcam.sh**: Sets up the necessary configurations for the application's execution and copies resources like HTML, CSS, Javascript, and CGI programs.
- **clear.sh**: Use when you need to modify or delete the Webcam application's content. It deletes the content copied by `webcam.sh`.

## 🚀 Setup Instructions
1. Begin by editing `setting.txt` and `target.txt` when setting up a new device. Use the commands:
   ```sh
   `vi setting.txt`
   `vi target.txt`
3. Execute the following scripts in order: 
   - `sudo sh apache.sh`
   - `sudo bash network.sh`
   - `sudo sh webcam.sh`
4. If modifications or deletions are needed, run:
   - `sudo sh clear.sh`
