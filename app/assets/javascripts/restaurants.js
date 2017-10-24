$( document ).ready(function() {
  initializeFavoriteRestaurantForm('.favorite form')
});

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

function submitForm(element) {
  var form = $(element).siblings('form')
  var animationArea = $(element).find('.ui.icon.header');

  animationArea
    .transition({
      animation : 'scale out',
      duration  : '0.2s',
      onComplete : function() {
        form.submit();
    }})
}

function initializeFavoriteRestaurantForm(form) {
  $(form).on("ajax:error", function(e, xhr, status, error) {
    if (error == 'Unauthorized') {
      var animationArea = $(this).siblings().find('.ui.icon.header');
      var msg = xhr.responseText;
      var messages = ('<div class="ui container messages"><div class="ui yellow message close"><i class="close icon"></i>' + msg + '</div></div>')

      handleSuccess(animationArea, messages);
    }
  })
}

function handleSuccess(element, messages){
  element
  .transition({
    animation  : 'scale in',
    duration   : '0.2s',
    onComplete : function() {
      renderMessages(messages);
    }
  })
}
