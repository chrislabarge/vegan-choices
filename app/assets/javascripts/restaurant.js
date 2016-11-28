$(document).ready(function(){
    $('.btn').each(function() {
        // alert($(this).parent())
        animationClick(this,  'bounceInUp', $(this).parent().find('.list-group'));
    });
});


function animateClick(element, animation){
    element = $(element);
    element.click(
        function() {
            element.addClass('animated ' + animation);
            //wait for animation to finish before removing classes
            window.setTimeout( function(){
                element.removeClass('animated ' + animation);
            }, 2000);

        });
}


function animationClick(element, animation, elementToAnimate = null){
    element = $(element);

    if (elementToAnimate === null) { //look how to refactor this out
      elementToAnimate = element
    } else {
      elementToAnimate = $(elementToAnimate)
    }

    element = $(element);

    element.click(
        function() {
            elementToAnimate.css('visibility', 'visible');
            elementToAnimate.addClass('animated ' + animation);
            //wait for animation to finish before removing classes
            window.setTimeout( function(){
                 elementToAnimate.removeClass('animated ' + animation);
            }, 2000);

        });
}



