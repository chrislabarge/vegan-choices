$(document).ready(function(){
  initializeRestaurantInputToggle();
});

function initializeRestaurantInputToggle() {
  $('#yes')
    .on('click', function() {
      $('.restaurant-input-toggle').toggle();
      $('.restaurant-input').toggle();
  });

  $('#no')
    .on('click', function() {
      $('.restaurant-input-toggle').toggle();
  });
}
