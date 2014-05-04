$(document).ready( function() {
    $('input.package-select').change( function() {
        if ($(this).val() > 0) {
            $('.employers-extra-information').fadeIn();
        } else {
           $('.employers-extra-information').fadeOut(); 
        }
    });
});
