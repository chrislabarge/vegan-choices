$(document).ready(function(){
  ajaxGetRequest('/restaurants', initializeLandingPageInput, null);
});

// function initializeLandingPageInput(data) {
//   initializeAutocompleteInput("#restaurantSearch", data);
// }

function initializeLandingPageInput(data) {
  console.log(data);

  $( "#restaurantSearch" ).select2({
      theme: "bootstrap",
      // data: data,
      multiple: true,
      maximumSelectionLength: 1,
      templateResult: formatRestaurant
  });
}
function formatRestaurant (restaurant) {
  // if (!state.id) { return state.text; }
  var $restaurant = $(
    '<span>' + restaurant.text + ' YOLOOOOOO</span>'

    // '<span><img src="vendor/images/flags/' + state.element.value.toLowerCase() + '.png" class="img-flag" /> ' + state.text + '</span>'
  );
  return $restaurant;
};