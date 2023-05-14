if (document.URL.match(/new/)){
  document.addEventListener('DOMContentLoaded', () => {

    const ImageList = document.getElementById('new-image');

    const createImageHTML = (blob) => {

      const imageElement = document.createElement('div');

      imageElement.setAttribute('class', "image-element")
      let imageElementNum = document.querySelectorAll('.image-element').length

      const blobImage = document.createElement('img');
      blobImage.setAttribute('class', 'new-img')
      blobImage.setAttribute('src', blob);

      imageElement.appendChild(blobImage);
      ImageList.appendChild(imageElement);

    };

    document.getElementById('post_images').addEventListener('change', (e) =>{

      ImageList.innerHTML = '';
      for( var i = 0; i < e.target.files.length; i++){
        var file = e.target.files[i];
        var blob = window.URL.createObjectURL(file);
        createImageHTML(blob);
      }
    });
  });
}
