async function loadImages() {
    try {
        const response = await fetch('/cgi-bin/list.cgi');
        if (!response.ok) {
            throw new Error('Server response was not ok.');
        }
        const images = await response.json();
        const list = document.getElementById('image-list');
        list.innerHTML = '';
        images.forEach(function(image) {
            var item = document.createElement('li');
            var link = document.createElement('a');
            link.href = '/images/' + image;
            link.textContent = image;
            item.appendChild(link);

            var renameInput = document.createElement('input');
            renameInput.type = 'text';
            renameInput.placeholder = "";
            item.appendChild(renameInput);

            var renameButton = document.createElement('button');
            renameButton.textContent = '変更';
            renameButton.addEventListener('click', async function() {
                var newName = renameInput.value.trim();
                if (newName === '') {
                    alert('名前を入力してください');
                    return;
                }
                console.log(newName)
                
                const renameResponse = await fetch('/cgi-bin/rename.cgi?old=' + image + '&new=' + encodeURI(newName));
                const text = await renameResponse.text();
                console.log('Image renamed:', text);
                loadImages();
            });
            item.appendChild(renameButton);

            list.appendChild(item);
        });
    } catch (error) {
        console.log('There has been a problem with your fetch operation: ' + error.message);
    }
}

function update() {
    var xhr = new XMLHttpRequest();
    xhr.open('GET', '/cgi-bin/update.cgi', true);
    xhr.onreadystatechange = function () {
        if (xhr.readyState == 4 && xhr.status == 200) {
            var result = xhr.responseText;
            alert(result); // CGIプログラムからの応答をそのまま表示
            // ここでページをリロード
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
    // バージョン情報を取得して表示
    fetch('/cgi-bin/version.cgi')
        .then(response => response.text())
        .then(version => {
            document.getElementById("version").textContent = version;
        });
}

function captureImage() {
    fetch('/cgi-bin/capture.cgi')
        .then(response => response.text())
        .then(data => {
            loadImages(); // 画像リストを再ロード
        })
        .catch(error => {
            console.error('Error capturing image:', error);
        });
}

document.addEventListener("DOMContentLoaded", function () {
    getIPAddress();
    getUserAgent();
    getVersion();
    loadImages();
});