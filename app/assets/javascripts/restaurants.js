function initializeSortDropdown() {
  $('.ui.dropdown')
    .dropdown({
      action: function(text, value) {
        $(this).dropdown('set selected', value)
        $(this).dropdown('hide')
        $('.ui.dropdown > .dropdown.icon').hide();
        $(this).closest('form').submit();
      }
  });
}

function initializeFavoriteRestaurantForm() {
  $('.submit')
  .on
    ('click', function() {
      $('#new_favorite').submit();
  });

  $('#new_favorite').on("ajax:error", function(e, xhr, status, error) {
    if (error == 'Unauthorized') {
      var msg = xhr.responseText;
      renderMessages('<div class="ui container messages"><div class="ui yellow message close"><i class="close icon"></i>' + msg + '</div></div>');

    }
  })
}


