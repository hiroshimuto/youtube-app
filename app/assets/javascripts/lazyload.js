$(function(){
  var videos = gon.videos ;
  // var html = ""

  videos.forEach(function( video ) {
    // var html = ""
    var frame = `
    <div class="video-title">${video.title}</div>
    <iframe width="560" height="315" src="https://www.youtube-nocookie.com/embed/${video.link}" frameborder="0" allowfullscreen></iframe>\n`
    $('.videos').append(frame);
  });
})

$(function(){
  $('.main').infinitescroll({
    navSelector  : ".navigation", // ページナビのクラス
    nextSelector : ".navigation a", // ページナビの次へリンクのクラス
    itemSelector : ".main .videos" // 記事のクラス
  });
});

// $(window).on('load', function(data){
//       $('#youtube-box').html('<iframe width="560" height="315" src="https://www.youtube-nocookie.com/embed/<%= gon.videos.link%>" frameborder="0" allowfullscreen></iframe>');
//     });
