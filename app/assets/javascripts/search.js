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
    error: { noResults: "<a href='/restaurants/new'>Click here</a> to add a new Restaurant and its vegan options" },
    type: 'special',
    minCharacters: 1,
    templates: restaurantSearchResultsTemplate(),
  });

  initializeSubmitIcons();
  initializeSearchMobileScrollTop();
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

function initializeSearchMobileScrollTop() {
  if ($(window).width() < 800) {
    if(/Android [4-8]\.[0-3]/.test(navigator.appVersion)) {
      window.addEventListener("resize", function(){
        if(document.activeElement.className == "prompt"){
          document.activeElement.scrollIntoView(true);
        }
      });
    } else {
      $('.search input').on('focus', function() {
        document.body.scrollTop += this.getBoundingClientRect().top// - 10 // space on top of the screen to give buffer between input
      });
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
