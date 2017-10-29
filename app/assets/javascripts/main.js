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
  runMobileScripts();
  setMobileNav();
});

function initializeInputToggle() {
  $('#yes')
    .on('click', function() {
      $(".form").find( ".hidden" ).toggle();
      $(".form .toggle").toggle();
  });

  $('#no')
    .on('click', function() {
      $('.form .toggle').toggle();
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

function runMobileScripts() {
  // if ($(window).width() < 700) {
  //   scrollToSearchInput();
  // }
}

function scrollToSearchInput() {
  // One way
  // $('#searchHero').on('focus', function() {
    //   document.body.scrollTop = $(this).offset().top;
    // });


    // Another way
  // The slingshot effect
  // $('.ui.search input').click(function(){
  //   var searchCoordinates = $(this).position().top;
  //   var body = $("html, body");
  //   body.animate({scrollTop: $(this).offset().top}, 1000, 'easeOutCubic', function() {
  //   });
  // })
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

function initializeMessages() {
  $('.message .close')
    .on('click', function() {
      $(this)
        .closest('.message')
        .transition('fade')
      ;
    })
  ;
}

function renderMessages(content) {
  $('.flash-messages').html(content)
  initializeMessages();
}

function initializeNestedFields() {
  $('#items').on('cocoon:after-insert', function(e, insertedItem) {
    $('#items .ui.dropdown')
      .dropdown()
    ;
  });
}
