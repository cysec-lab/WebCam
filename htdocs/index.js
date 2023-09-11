function update() {
    var xhr = new XMLHttpRequest();
    xhr.open('GET', '/cgi-bin/update.cgi', true);
    xhr.onreadystatechange = function () {
        if (xhr.readyState == 4 && xhr.status == 200) {
            var result = xhr.responseText;
            alert(result);
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
        }
    };
    xhr.send();
}

function updateIframe() {
    let iframe = document.getElementById("cameraIframe");
    iframe.src = "image.html?time=" + new Date().getTime(); // タイムスタンプを付けてキャッシュを防ぐ
}

function getUserInfo() {
    // UserInfo.cgiからすべての情報を取得する
    fetch('/cgi-bin/UserInfo.cgi')
        .then(response => response.json()) // CGIがJSON形式でデータを返すと仮定
        .then(data => {
            document.getElementById('version').textContent = data.version;
            document.getElementById('ip-address').textContent = data.ip_address;
            document.getElementById('user-agent').textContent = data.user_agent;
        })
        .catch(error => {
            console.error('Error fetching user info:', error);
        });
}

document.addEventListener("DOMContentLoaded", function () {
    getUserInfo();
    setInterval(updateIframe, 5000); // 5秒ごとにupdateIframe関数を呼び出す
});
