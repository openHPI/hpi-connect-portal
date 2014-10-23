$(document).ready( function() {
    if ($('input.package-select:checked').val() > 0) $('.employers-extra-information').show();
    $('input.package-select').change( function() {
        if ($(this).val() > 0) {
            $('.employers-extra-information').fadeIn();
        } else {
           $('.employers-extra-information').fadeOut(); 
        }
    });

    
    if($('div.star-percent').length > 0) {
        var partial_star = $("div.star-percent").attr("class").match(/star-percent-\d+/g);
        
        var percentage = parseInt(partial_star.toString().split("-")[2])/100;
        var position = Math.round(16-16*percentage) + "px";
        alert($(partial_star).length);
        $(partial_star).css({ "background-position":  "-8 -8" });
        
    }
});
