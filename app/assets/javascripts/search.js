$(document).ready(function(){
  var baseUrl = window.location.origin;

  initializeRestaurantSearch(baseUrl);
  initializeGooglePlacesSearch(baseUrl);
  initializeSubmitIcons();
  initializeSearchMobileScrollTop();
});

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

function initializeRestaurantSearch(url) {
  $('.ui.search.restaurant').search({
    apiSettings: {
      url: url + '/search/restaurants?q={query}'
    },
    onSelect: function(result) {
      document.location.href = result.url
    },
    fields: {
      results : 'restaurants',
      itemCount : 'itemCount',
      veganMenu : 'veganMenu'
    },
    error: { noResults: "<a href='/restaurants/new'>Click here</a> to add a new Restaurant and its vegan options" },
    type: 'special',
    minCharacters: 1,
    templates: restaurantSearchResultsTemplate(),
  });
}

function initializeGooglePlacesSearch(url) {
  var path = window.location.pathname
  $('.ui.search.places').search({
    apiSettings: {
      url: url + '/search/google-places?q={query}&path=' + path
    },
    minCharacters : 3,
    searchDelay: 250
  });
}

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

          html += rightRowContent(result, fields);

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

function rightRowContent(result, fields) {
  var content = '';

  content += '<div class="item-count">';

  if (result[fields.veganMenu] === true) {
    content += '<span class="highlight">' + 'Vegan Menu' + '</span>';
  } else if(result[fields.itemCount] !== undefined ) {
    count = result[fields.itemCount];
    content += itemCountContent(count);
  }

  content  += '' + '</div>';

  return content;
}

function itemCountContent(count) {
  suffix = determineSuffix(count);

  if(count > 0) {
    boldValue = count;
  } else {
    boldValue = 'Add';
  }

  return '<span class="highlight">' + boldValue + '</span>' +  ' ' + suffix;
}
function determineSuffix(count) {
  suffix = 'Option';
  if(count > 1) {
    suffix += 's';
  }

  return suffix;
}
