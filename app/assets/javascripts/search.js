$(document).ready(function(){
  var baseUrl = window.location.origin;

  $('.ui.search').search({
    apiSettings: {
      url: baseUrl + '/search/restaurants?q={query}'
    },
    onSelect: function(result) {
      document.location.href = result.url
    },
    fields: {
      results : 'restaurants',
      itemCount : 'itemCount'
    },
    type: 'special',
    minCharacters: 1,
    templates: restaurantSearchResultsTemplate(),
  });

  initializeSubmitIcons();
});

function restaurantSearchResultsTemplate() {
  return {
      special: function(response, fields) {
        var html = '';
        if(response[fields.results] !== undefined) {
          $.each(response[fields.results], function(index, result) {
            if(result[fields.url]) {
              html  += '<a class="result" href="' + result[fields.url] + '">';
            }
            else {
              html  += '<a class="result">';
            }

            html += '<div class="content">';

            if(result[fields.image] !== undefined) {
              html += ''
                + '<div class="search image">'
                + ' <img src="' + result[fields.image] + '">'
                + '</div>'
              ;
            }

            if(result[fields.title] !== undefined) {
              html += '<div class="title">' + result[fields.title] + '</div>';
            }

            html += '<div class="item-count">';

            if(result[fields.itemCount] !== undefined) {
              console.log(result);
              html += '<span class="highlight">' + result[fields.itemCount] + '</span>' +  ' Items';
            }

            html  += '' + '</div>';
            html  += '' + '</div>';
            html += '</a>';
          });

          if(response[fields.action]) {
            html += ''
            + '<a href="' + response[fields.action][fields.actionURL] + '" class="action">'
            +   response[fields.action][fields.actionText]
            + '</a>';
          }

          return html;
        }
        return false;
      }
    }
}

function initializeSubmitIcons() {
  $('.search.link')
    .on
      ('click', function() {
        $(this).closest('form').submit();
  });
}
