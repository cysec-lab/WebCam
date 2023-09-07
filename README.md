## 📄 Description of Text Files
- **setting.txt**: Used for setting static IP addresses, DNS, and Router configurations. Modify the values based on your desired settings.
- **target.txt**: Specifies the server to which images will be sent, and determines the ID and API token required for transmission.

## 🛠️ Description of Shell Scripts
- **apache.sh**: Installs apache2.4.49. Installation typically takes around 20-30 minutes.
- **network.sh**: Reads and applies the configurations from `setting.txt`.
- **webcam.sh**: Handles the necessary settings for application execution, and copies resources such as HTML, CSS, Javascript, and CGI programs.
- **clear.sh**: To be used when you want to modify or delete the Webcam application's content. It removes the items copied by `webcam.sh`.

## 🚀 Setting Up Instructions
1. Start by editing `setting.txt` and `target.txt` when setting up a new device.
2. Execute the scripts in the following sequence: `apache.sh`, `network.sh`, and `webcam.sh`.
3. Run `clear.sh` if modifications or deletions are needed.
