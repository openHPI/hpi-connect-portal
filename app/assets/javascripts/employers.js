$(document).ready( function() {
    if ($('input.package-select:checked').val() > 0) $('.employers-extra-information').show();
    $('input.package-select').change( function() {
        if ($(this).val() > 0) {
            $('.employers-extra-information').fadeIn();
        } else {
           $('.employers-extra-information').fadeOut(); 
        }
    });
});
