function loadModal(modalId, modalContent) {
  fillAndDisplayModal(modalId, modalContent);
}

function fillAndDisplayModal(id, content) {
  $('.modal').html(content)
  $('.modal .close').click(function() {
    hideModal('.ui.modal');
  });

  initializeModal(id);
  displayModal('.ui.modal');
}

function initializeModal (id) {
  if ( !$('#' + id).length ) {
    $('.modal').attr('id', id);
  }
}

function displayModal(selector) {
  $('body').removeClass('dimmed')
  $(selector).modal('show')
}

function hideModal(selector) {
  $(selector).modal('hide')
}

function changeToggleButton(initialToggle, newToggleContent) {
  revertTogggleButtons();

  toggleModalButtons(initialToggle, newToggleContent);
  initializePopup();
}

// adding the new node element that toggles the modal, if one does not already exist
function toggleModalButtons(remoteRequestSelector, newToggleContent) {
  var remoteRequester = $(remoteRequestSelector);
  var wrapper = remoteRequester.parent();

  remoteRequester.hide();
  display_modal_toggle(wrapper);
}

function display_modal_toggle(wrapper) {
  // find existing toggle Selector
  var existingToggleSelector = wrapper.find('.toggle-modal');
  // if there is not already a toggle modal node, then create one, if there is, then just show that one.
  if (existingToggleSelector.length === 0) {
    wrapper.append(newToggleContent)
    initializeModalToggle();
  } else {
    existingToggleSelector.show();
  }
}

function initializeModalToggle(params) {
  $('.ui.modal')
    .modal('attach events', '.toggle-modal', 'show')
  ;
}

function initializeGestures() {
  if (window.hammertime !== undefined) { return }

  var modal_overlay = document.getElementsByClassName('dimmer')[0];
  window.hammertime = new Hammer(modal_overlay);

  window.hammertime.on('swipe', function() {
    hideModal('.ui.modal')
  });
}

// remove the current "display modal toggle buttons"
function revertTogggleButtons() {
  var modalToggle = $("body").find(".toggle-modal");
  modalToggle.hide();
  modalToggle.parent().find('a.toggle').show();
}

function removeLoadingDimmer() {
  $('.ui.active.inverted.dimmer').remove();
}
