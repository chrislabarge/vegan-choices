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
                   showHintOnFocus: true,
                   afterSelect: submitRestaurantSearchForm,
                   item: '<li  class="dropdown-item"><a href="#" role="option"></a><span class="tag tag-default tag-pill float-xs-right items menu">1 Menu Items</span><span class="tag tag-default tag-pill float-xs-right items non-menu">1 Other Items</span></li>',
                  //  highlighter: function (item) {
                  //       var parts = item.split('#')
                  //       var name = parts[0].replace(new RegExp('(' + something + ')', 'ig'), function ($1, match) {
                  //           return '<strong>' + match + '</strong>'
                  //       });
                  //       var html = '<div class="typeahead">';
                  //       html += '<div class="pull-left margin-small">';
                  //       html += '<div class="text-left">' + name + '</div>';
                  //       html += '<div class="text-left">' + parts[1] + '</div>';
                  //       html += '</div>';
                  //       html += '<div class="clearfix"></div>';
                  //       html += '</div>';
                  //       item = 'test'
                  //       return html;

                  //   },
                  //   source: function (query, process) {

                  //       var employees = [];
                  //       // Look to see if I should change this to a AJAX request
                  //       return $.get('/restaurants.json', function (data) {

                  //           // Loop through and push to the array
                  //           $.each(data, function (i, e) {
                  //               employees.push(e.name + "#" + e.menu_item_count);
                  //           });

                  //           something = query
                  //           // Process the details
                  //           process(employees);
                  //       });

                  //   }
                });

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
      //     // Nothing is active so it is a new valuec (or maybe empty value)
      // }
  });
};

function something(item) {
  alert(item.non_menu_item_count)
  alert('hello')
  return item
}

function submitRestaurantSearchForm() {
  $( "#restaurantSearchForm" ).submit();
}