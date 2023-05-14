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
      // const imageContent = document.querySelector('img');
      // if (imageContent){
      //   imageContent.remove();
      // }
      ImageList.innerHTML = '';
      for( var i = 0; i < e.target.files.length; i++){
        var file = e.target.files[i];
        var blob = window.URL.createObjectURL(file);
        createImageHTML(blob);
      }
    });
  });
}

// if (document.URL.match(/new/)){
// document.addEventListener('DOMContentLoaded', function(){
//   if ( document.getElementById('item-image')){
//     const ImageList = document.getElementById('image-list');

//     const createImageHTML = (blob, target) => {

//       // 既に画像表示エリアが存在するなら img の src だけ更新
//       let preview = document.querySelector(`img[data-for="${target.id}"]`);
//       if (preview) {
//           preview.setAttribute('src', blob);
//           return;
//       }

//       // 画像を表示するためのdiv要素を生成
//       const imageElement = document.createElement('div');
//       imageElement.setAttribute('class', "image-element")
//       let imageElementNum = document.querySelectorAll('.image-element').length

//       // 表示する画像を生成
//       const blobImage = document.createElement('img');
//         blobImage.className="img-preview";
//         blobImage.dataset.for = target.id;
//         blobImage.setAttribute('src', blob);

//       // 画面上のファイル選択ボタンが上限に達していないなら、ファイル選択ボタンを生成
//       const imageInputNum = document.querySelectorAll('input[name="post[images][]"]').length;
//       const limit = 5;
//       if(imageInputNum < limit) {
//         const inputHTML = document.createElement('input')
//         inputHTML.setAttribute('id', `item-image_${imageElementNum}`)
//         inputHTML.setAttribute('name', 'post[images][]')
//         inputHTML.setAttribute('type', 'file')

//         imageElement.appendChild(inputHTML)

//         inputHTML.addEventListener('change', (e) => {
//         file = e.target.files[0];
//         blob = window.URL.createObjectURL(file);

//         createImageHTML(blob, e.target)
//         })
//       }

//       document.getElementById('item-image').addEventListener('change', function(e){
//       const file = e.target.files[0];
//       const blob = window.URL.createObjectURL(file);

//       createImageHTML(blob, e.target);
//     });
//   }
// }});
// }