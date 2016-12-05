function toggleNested (element) {
  $(element)
    .parent()
    .children('.nested')
    .toggle();
 }