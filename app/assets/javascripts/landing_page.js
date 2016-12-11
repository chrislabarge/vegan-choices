$(document).ready(function(){
  $( "#restaurantSearch" ).one('focus', function() {
      ajaxGetRequest('/restaurants', initializeLandingPageInput);
  });

  function initializeLandingPageInput(data) {
    initializeAutocompleteInput("#restaurantSearch", data);
  }
});
