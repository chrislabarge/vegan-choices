$(document).ready(function(){
  $( ".toggle-ingredients" ).click(function() {
      $( ".item_ingredients" ).toggle();
  });

  $('.message .close')
    .on('click', function() {
      $(this)
        .closest('.message')
        .transition('fade')
      ;
  });
});
