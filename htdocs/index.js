async function takePicture() {
    try {
        const response = await fetch('/cgi-bin/takepicture.cgi', {
            method: 'GET',
            mode: 'same-origin',
            credentials: 'include'  // クレデンシャルをリクエストに含める
        });
        
        if (!response.ok) {
            throw new Error('Server response was not ok. Status code: ' + response.status);
        }
        document.getElementById('latestImage').src = "/images2/now.jpg?" + new Date().getTime();
    } catch (error) {
        console.error('Error taking picture:', error);
    }
}

function update() {
    var xhr = new XMLHttpRequest();
    xhr.open('GET', '/cgi-bin/update.cgi', true);
    xhr.onreadystatechange = function () {
        if (xhr.readyState == 4 && xhr.status == 200) {
            var result = xhr.responseText;
            alert(result);
            location.reload();
        }
    };
    xhr.send();
}

function resetCamera() {
    var xhr = new XMLHttpRequest();
    xhr.open('GET', '/cgi-bin/reset.cgi', true);
    xhr.onreadystatechange = function () {
        if (xhr.readyState == 4 && xhr.status == 200) {
            var result = xhr.responseText;
            alert(result);
            location.reload();
        }
    };
    xhr.send();
}

function getIPAddress() {
    fetch('/cgi-bin/ip.cgi')
        .then(response => response.text())
        .then(data => {
            document.getElementById('ip-address').textContent += data;
        })
        .catch(error => {
            console.error('Error fetching IP address:', error);
        });
}

function getUserAgent() {
    document.getElementById('user-agent').textContent += navigator.userAgent;
}

function getVersion() {
    fetch('/cgi-bin/version.cgi')
        .then(response => response.text())
        .then(version => {
            document.getElementById("version").textContent = version;
        });
}

document.addEventListener("DOMContentLoaded", function () {
    takePicture();
    getIPAddress();
    getUserAgent();
    getVersion();
});
