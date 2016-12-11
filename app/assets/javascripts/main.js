$(document).ready(function(){
  $('.modal').on('hide.bs.modal', function () {
     $('nav.navbar').css('visibility','visible');
  })

  $('.display-ingredients').on('click', function () {
     $('nav.navbar').css('visibility','hidden');
  })
});

function ajaxGetRequest(url, callback, error) {
  $.ajax({ type: 'GET',
    contentType: "application/json",
    url: url,
    dataType: "json",
    success: function(data) { callback(data) },
    error: function(request) {
             ajaxError(request)
             error
           }
  });
}

function ajaxError(request) {
  console.log('Received AJAX error message: ' + request.responseText)
}

function initializeAutocompleteInput(inputSelector, source) {
  var $input = $(inputSelector);

  $input.typeahead({source: source,
                   autoSelect: true,
                   afterSelect: submitRestaurantSearchForm,
                   item: '<li  class="dropdown-item"><a href="#" role="option"></a></li>'});

  $input.change(function() {
      $input.typeahead("getActive");

      // HOW TO CUSTOMIZE MATCH EVENTS
      // var current = $input.typeahead("getActive");

      // if (current) {
      //     // Some item from your model is active!

      //     if (current.name == $input.val()) {
      //         // This means the exact match is found. Use toLowerCase() if you want case insensitive match.
      //     } else {
      //         // This means it is only a partial match, you can either add a new item
      //         // or take the active if you don't want new items
      //     }
      // } else {
      //     // Nothing is active so it is a new value (or maybe empty value)
      // }
  });
};

function submitRestaurantSearchForm() {
  $( "#restaurantSearchForm" ).submit();
}