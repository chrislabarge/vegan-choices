$(document).ready(function(){
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
});

function toggleNested (parent, childClass) {
  $(parent)
    .parent()
    .children(childClass)
    .toggle();
}
