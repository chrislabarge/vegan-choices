$(document).ready(function(){
  $('.modal').on('hide.bs.modal', function () {
     $('nav.navbar').css('visibility','visible');
  })

  $('.display-ingredients').on('click', function () {
     $('nav.navbar').css('visibility','hidden');
  })
});
