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

window.onload = function() {
    document.getElementById("updateButton").addEventListener("click", async function() {
        await fetch('/cgi-bin/update.cgi');
    });

    document.getElementById('capture-button').addEventListener('click', async function() {
        const response = await fetch('/cgi-bin/capture.cgi');
        const text = await response.text();
        console.log('Image captured:', text);
        loadImages();
    });
};

function update() {
    var xhr = new XMLHttpRequest();
    xhr.open('GET', '/cgi-bin/update.cgi', true);
    xhr.onreadystatechange = function () {
        if (xhr.readyState == 4 && xhr.status == 200) {
            var result = xhr.responseText;
            if (result.includes("Download succeeded!")) {
                alert("Update succeeded!");
            } else {
                alert("Update failed!");
            }
        }
    };
    xhr.send();
}
