function initializePhotoGallery() {
  if ($('.carousel-photos').length === 0) {
    return;
  }

  initializeArrows();
  initializPhotoGalleryGestures();

  $('.hide-accordion').on('click', function() {
    $('.ui.accordion').accordion('close', 0)
  })
}

function initializeArrows() {
  $('.carousel .left.icon').on('click', function() {
    cycleThroughGallery('left')
  })

  $('.carousel .right.icon').on('click', function() {
    cycleThroughGallery('right')
  })
}

function cycleThroughGallery(direction) {
  images = $('.header-img')
  active = $('.header-img.active')
  current_index = images.index(active)

  index = findGalleryIndex(images, current_index, direction);

  visiblePhoto = $(images[current_index])
  nextPhoto = $(images[index])

  handleTransition(visiblePhoto, nextPhoto, direction);
}

function findGalleryIndex(images, current_index, direction) {
  var index;

  if (direction === 'left') {
    index = current_index - 1;
    if (index < 0) {
      index = (images.size() - 1);
    }
  }

  if (direction === 'right') {
    index = current_index + 1;

    if (index === images.size()) {
      index = 0;
    }
  }

  return index;
}

function handleTransition(visiblePhoto, nextPhoto, direction) {

  visiblePhoto.transition({
    animation  : 'fade ' + direction,
    duration   : '0.2s',
    onComplete : function() {
      visiblePhoto.removeClass('active').addClass('hidden');
      nextPhoto.removeClass('hidden').addClass('active');
      nextPhoto.transition('fade in ' + direction)
    }
  })
}

function initializPhotoGalleryGestures() {
  if (window.hammertime !== undefined) { return; }

  window.hammertime = new Hammer(document.getElementsByClassName('carousel-photos')[0]);

  window.hammertime.on('swipeleft', function() {
    cycleThroughGallery('right')
  });
  window.hammertime.on('swiperight', function() {
    cycleThroughGallery('left')
  });
}

