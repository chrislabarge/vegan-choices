$(document).ready(function(){
  $( ".toggle-ingredients" ).click(function() {
      $( ".item_ingredients" ).toggle();
  });

  $('.ui.modal')
    .modal( {inverted: true })
    .modal('setting', 'transition', 'fade down')
  ;
  $('.message .close')
    .on('click', function() {
      $(this)
        .closest('.message')
        .transition('fade')
      ;
  });


  $( ".toggle-nested-ingredients" ).click(function() {
      // $( ".item_ingredients" ).toggle();
      toggleNested(this);
  });


  // $('.toggle-ingredients').click({
  //   onChange: function(value) {
  //     $('.ui.modal')
  //       // .modal('setting', 'transition', value)
  //       .modal( {inverted: true })
  //       .modal('show')
  //     ;
  //   }
  // });
});

function toggleNested (element) {
  alert(element);
  $(element)
    .parent()
    .children('.nested-ingredients')
    .toggle();
}
