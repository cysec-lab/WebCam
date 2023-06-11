document.getElementById('capture-button').addEventListener('click', function() {
    fetch('/cgi-bin/capture.cgi').then(function(response) {
        return response.text();
    }).then(function(text) {
        console.log('Image captured:', text);
        loadImages();
    });
});

function loadImages() {
    fetch('/cgi-bin/list.cgi').then(function(response) {
        return response.json();
    }).then(function(images) {
        var list = document.getElementById('image-list');
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
            renameButton.addEventListener('click', function() {
                var newName = renameInput.value;
                console.log(newName)
                // Do not append the ".jpg" extension to the new name
                fetch('/cgi-bin/rename.cgi?old=' + image + '&new=' + newName).then(function(response) {
                    return response.text();
                }).then(function(text) {
                    console.log('Image renamed:', text);
                    loadImages();
                });
            });
            item.appendChild(renameButton);

            list.appendChild(item);
        });
    });
}

loadImages();


function takePicture() {
    fetch('/cgi-bin/takepicture.cgi')
        .then(function(response) {
            return response.text();
        })
        .then(function(text) {
            console.log('Picture taken:', text);
            document.getElementById('latestImage').src = "/images/now.jpg?"+new Date().getTime();
        });
}

//Update
window.onload = function() {
    document.getElementById("updateButton").addEventListener("click", function() {
        fetch('http://localhost/cgi-bin/update.cgi');
    });
}
