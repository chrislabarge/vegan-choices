$(document).ready(function(){
  $( ".toggle-ingredients" ).click(function() {
      $( ".item_ingredients" ).toggle();
  });

  $('.ui.search').search({
      //source: content
  });

  $('.ui-test').click(function() {
      $('.ui.modal').modal('show');
  });
});