$(document).ready(function($) {
    $(".clickable").click(function() {
        window.document.location = $(this).attr("href");
    });
});