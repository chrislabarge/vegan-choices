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

    initializeLoader('Loading');
  });

  $('.ui.accordion').accordion();

  $('#top').click(function(){
      var body = $("html, body");
      body.stop().animate({scrollTop:0}, 1000, 'easeInOutExpo', function() {
      });
  });

  setMobileNav();
});

function initializeLoader(content) {
  $('body').append("<div class='ui active inverted dimmer'><div class='ui large text loader'>" + content + "</div></div><p></p><p></p><p></p>");
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

