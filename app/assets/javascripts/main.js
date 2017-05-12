$(document).ready(function(){
  $('.ui.modal')
    .modal( {inverted: true })
    .modal('setting', 'transition', 'fade down')
  ;

  $('.message .close')
    .on('click', function() {
      $(this)
        .closest('.message')
        .transition('fade')
      ;
  });

  $('.toggle-ingredients').click(function() {
    window.remoteRequestButton = $(this);

    initializeLoader();
  });

  $('.ui.accordion').accordion();

  setMobileNav();
});

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

  $('.sidebar a i.close').on('click', function() {
    $('.ui.sidebar').sidebar('hide');
  })
}

