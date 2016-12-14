$(document).ready(function(){
  ajaxGetRequest('/restaurants', initializeLandingPageInput);
});

function initializeLandingPageInput(data) {
  initializeAutocompleteInput("#restaurantSearch", data);
}
