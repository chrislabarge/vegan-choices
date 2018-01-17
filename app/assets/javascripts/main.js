$(document).ready(function(){
  $('.ui.modal')
    .modal( {inverted: true })
    .modal('setting', 'transition', 'fade down')
  ;

  $('.ui.dropdown')
    .dropdown()
  ;

  $('.toggle-ingredients').click(function() {
    window.remoteRequestButton = $(this);

    initializeLoader();
  });

  $('.ui.accordion').accordion();

  initializeNestedFields();
  initializeMessages();
  initializeInputToggle();
  setMobileNav();
  initializePopup();
});

function initializeInputToggle() {
  var toggleElement = ".form .toggle"
  var hiddenElements = $(".form").find( ".field.hidden" )

  $('#yes')
    .on('click', function() {
      $(toggleElement).transition({
        animation  : 'scale out',
        duration   : '0.2s',
        onComplete : function() {
          scaleIn(hiddenElements);
        }
      });
    });

  $('#no')
    .on('click', function() {
      scaleOut(toggleElement);
  });
}

function scaleOut(selector) {
  $(selector).transition({
    animation  : 'scale out',
    duration   : '0.2s'
  });
}
function scaleIn(selector) {
  selector.transition({
    animation  : 'scale in',
    duration   : '0.2s'
  });
}

function initializeLoader() {
  $('body').append("<div class='ui active inverted dimmer'><div class='ui large text loader'>Loading</div></div><p></p><p></p><p></p>");
  $('body').addClass('dimmed')
}

function toggleNested (parent, childClass) {
  $(parent)
    .parent()
    .children(childClass)
    .toggle();
}

function setMobileNav() {
  $('.ui.sidebar')
    .sidebar('setting', {
      dimPage          : false,
      transition       : 'overlay',
      mobileTransition : 'overlay',
      scrollLock: true,
      returnScroll: true
    })
  ;

  $('a.launch').on('click', function() {
    $('.ui.sidebar').sidebar('toggle');
  })

  $('.sidebar .close').on('click', function() {
    $('.ui.sidebar').sidebar('hide');
  })

  var sidebar = document.getElementsByClassName('ui sidebar')[0];

  var hammertime = new Hammer(sidebar);

  hammertime.on('swipe', function() {
    $('.ui.sidebar').sidebar('hide');
  });
}

function selectToggle(value, toggleValue) {
  var hiddenInput = $('.field.hidden');

  if (value === toggleValue) {
    hiddenInput.toggle();
  } else {
    if (hiddenInput.is(":visible")) {
      hiddenInput.toggle();
    };
  };
}

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

function initializePopup() {
  $('.popup')
    .popup()
  ;
}
