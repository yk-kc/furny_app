$(function() {
  $('.top-image').hide().fadeIn(1600);
})

$(function () {
  $('.top-text').each(function () {
    var $this = $(this);
    // 1文字ずつ<span>で囲む
    $this
      .contents()
      .each(function () {
        if (this.nodeType == 3) {
          $(this).replaceWith(
            $(this).text().replace(/(\S)/g, "<span>$1</span>")
          );
        }
      });
    // 0.8秒後に要素を表示
    setTimeout(function () {
      $this.css({ opacity: 1 });
      $this
        .find("span")
        .each(function (i) {
          $(this)
            .delay(100 * i) // 文字間の時間
            .animate({ opacity: 1 }, 500); // 全部表示されるまでの時間
        });
    }, 800); // 0.8秒後に実行
  });
});