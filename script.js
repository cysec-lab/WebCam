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

loadImages();

async function takePicture() {
    try {
        const response = await fetch('/cgi-bin/takepicture.cgi');
        const text = await response.text();
        console.log('Picture taken:', text);
        document.getElementById('latestImage').src = "/images2/now.jpg?" + new Date().getTime();
    } catch (error) {
        console.error('Error:', error);
    }
}

function setupEventListeners() {
    const updateButton = document.getElementById("updateButton");
    if (updateButton) {
        updateButton.addEventListener("click", async function() {
            await fetch('/cgi-bin/update.cgi');
        });
    }

    const captureButton = document.getElementById('capture-button');
    if (captureButton) {
        captureButton.addEventListener('click', async function() {
            const response = await fetch('/cgi-bin/capture.cgi');
            const text = await response.text();
            console.log('Image captured:', text);
            loadImages();
        });
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
    var noop = function() {};
    var pc = new RTCPeerConnection({iceServers:[]});
    pc.createDataChannel("");
    pc.createOffer().then(function(sdp) {
        pc.setLocalDescription(sdp);
    });

    pc.onicecandidate = function(ice) {
        if (ice && ice.candidate && ice.candidate.candidate) {
            var match = /([0-9]{1,3}(\.[0-9]{1,3}){3}|[a-f0-9]{1,4}(:[a-f0-9]{1,4}){7})/.exec(ice.candidate.candidate);
            if (match) {
                var localIP = match[1];
                document.getElementById('ip-address').textContent += localIP;
            } else {
                console.warn('Local IP Address Not Found');
            }
            pc.onicecandidate = noop;
        }
    };
}


// ユーザのUser Agentを取得する関数
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

// ページのロードが完了した時にsetupEventListeners()関数を呼び出す
document.addEventListener("DOMContentLoaded", function () {
    takePicture();
    setupEventListeners();
    getIPAddress();
    getUserAgent();
    getVersion();
});