$( document ).ready(function() {
  initializeAjaxForm('.favorite form');
  initializeAjaxForm('.berry form');
});

function submitForm(element) {
  var form = $(element).siblings('form')
  var animationArea = $(element).find('.ui.icon');

  animationArea
    .transition({
      animation : 'scale out',
      duration  : '0.2s',
      onComplete : function() {
        form.submit();
    }})
}

function initializeAjaxForm(form) {
  $(form).on("ajax:error", function(e, xhr, status, error) {
    if (error == 'Unauthorized') {
      var animationArea = $(this).siblings().find('.ui.icon.header');
      var msg = xhr.responseText;
      var messages = ('<div class="ui messages"><div class="ui yellow message">' + msg + '</div></div>')

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
