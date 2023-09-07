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
            var row = document.createElement('tr');
            var cell = document.createElement('td');
            
            var link = document.createElement('a');
            link.href = '/images/' + image;
            link.textContent = image;
            link.className = 'filename';
            
            var renameInput = document.createElement('input');
            renameInput.type = 'text';
            renameInput.placeholder = "";
            
            var renameButton = document.createElement('button');
            renameButton.textContent = '変更';
            renameButton.addEventListener('click', async function() {
                var newName = renameInput.value.trim();
                if (newName === '') {
                    alert('名前を入力してください');
                    return;
                }
                
                const renameResponse = await fetch('/cgi-bin/rename.cgi?old=' + image + '&new=' + encodeURI(newName));
                const text = await renameResponse.text();
                
                loadImages();
            });

            cell.appendChild(link);
            cell.appendChild(renameInput);
            cell.appendChild(renameButton);
            
            row.appendChild(cell);
            list.appendChild(row);
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
    loadImages();
});

