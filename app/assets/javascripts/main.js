$(document).ready(function(){
  $( ".toggle-ingredients" ).click(function() {
      $( ".item_ingredients" ).toggle();
  });

  $('.ui.search').search({
    apiSettings: {
      url: 'search/restaurants?q={query}'
    },
    fields: {
      results : 'results',
      title   : 'name',
      url     : 'website'
    },
    minCharacters : 1
  });

  $('.ui-test').click(function() {
      $('.ui.modal').modal('show');
  });
});