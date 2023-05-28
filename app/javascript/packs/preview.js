if (document.URL.match(/new/)){
  $(document).ready(function() {
    // ドラッグアンドドロップエリアのイベントリスナーを追加
    var dropzone = document.getElementById('dropzone');
    dropzone.addEventListener('dragover', handleDragOver, false);
    dropzone.addEventListener('drop', handleFileSelect, false);

    // ドラッグオーバー時のイベントハンドラ
    function handleDragOver(event) {
      event.stopPropagation();
      event.preventDefault();
      event.dataTransfer.dropEffect = 'copy';
    }

    // ドロップ時のイベントハンドラ
    function handleFileSelect(event) {
      event.stopPropagation();
      event.preventDefault();

      var files = event.dataTransfer.files;
      var d = (new $.Deferred()).resolve();

      $.each(files, function(i, file) {
        d = d.then(function() {
          return Uploader.upload(file);
        }).then(function(data) {
          return previewImage(file, data.image_id);
        });
      });
    }

    $('#post_images').on('change',function(e){
      var files = e.target.files;
      var d = (new $.Deferred()).resolve();
      $.each(files,function(i,file){
        d = d.then(function() {
            return Uploader.upload(file)})
          .then(function(data){
            return previewImage(file, data.image_id);
        });
      });
      $('#post_images').val('');
    });


    $('.images-field').on('click','.btn-edit', function(e){
      e.preventDefault();
      $(this).parent().find('.edit-image-file-input').trigger("click");
    });

    $('.images-field').on('change','.edit-image-file-input', function(e){
      var file = e.target.files[0];
      var image_box = $(this).parent();
      Uploader.upload(file).done(function(data){
        replaceImage(file, data.image_id, image_box);
      });
    });

    $('.images-field').on('click','.btn-delete', function(e){
      e.preventDefault();
      $(this).parent().remove();
    });

    var replaceImage = function(imageFile, image_id, element){
      var reader = new FileReader();
      var img = element.find('img');
      var input = element.find('.post-images-input');
      var filename = element.find('p');
      reader.onload = function(e){
        input.attr({value: image_id});
        filename.html(imageFile.name);
        img.attr("src", e.target.result);
      };
      reader.readAsDataURL(imageFile);
    }


    var previewImage = function(imageFile, image_id){
      var reader = new FileReader();
      var img = new Image();
      var def =$.Deferred();
      reader.onload = function(e){
        var image_box = $('<div>',{class: 'image-box'});
        image_box.append(img);
        image_box.append($('<input>').attr({
              name: "post[images][]",
              value: image_id,
              style: "display: none;",
              type: "hidden",
              class: "post-images-input"}));
        image_box.append('<a href="" class= "btn-edit">Edit</a>');
        image_box.append($('<input>').attr({
              name: "edit-image[]",
              style: "display: none;",
              type: "file",
              class: "edit-image-file-input file-input"}));
        image_box.append('<a href="" class="btn-delete">Delete</a>');
        $('.images-field').append(image_box);
        img.src = e.target.result;
        def.resolve();
      };
      reader.readAsDataURL(imageFile);
      return def.promise();
    }


    var Uploader = {
      upload: function(imageFile){
        var def =$.Deferred();
        var formData = new FormData();
        formData.append('image', imageFile);
        $.ajax({
          type: "POST",
          url: '/posts/upload_image',
          data: formData,
          dataType: 'json',
          processData: false,
          contentType: false,
          success: def.resolve
        })
        return def.promise();
      }
    }
  })
}