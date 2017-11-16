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

function initializeReportReasonForm(toggleValue) {
  $('.ui.dropdown')
    .dropdown({
      action: function(text, value) {
        $(this).dropdown('set selected', value)

        selectToggle(value, toggleValue)

       $(this).dropdown('hide')
      }
  });
}

function initializeMessages() {
  $('.message .close')
    .on('click', function() {
      removeThis = $(this).closest('.message');
      fadeOut(removeThis);
    })
  ;

  $('.form-errors .message .close')
    .on('click', function() {
      removeThis = $(this).closest('.form-errors');
      fadeOut(removeThis);
    })
  ;
  setTimeout(function(){ fadeOut('.menu-bar .ui.message'); }, 4000);
}


function fadeOut(selector) {
  $(selector).transition({
    animation  : 'fade up out',
    duration   : '0.5s',
    onComplete : function() {
      removeMessages($(this))
    }
  });
}


function removeMessages(node) {
  node.closest('.ui.messages').remove();
}

function renderMessages(content) {
  $('.flash-messages').html(content)
  $('.ui.message').transition({
    animation  : 'fade up in',
    duration   : '0.5s',
  });
  initializeMessages();
}

function initializeNestedFields() {
  $('#items').on('cocoon:after-insert', function(e, insertedItem) {
    $('#items .ui.dropdown')
      .dropdown()
    ;
  });
}

