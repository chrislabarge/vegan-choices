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
