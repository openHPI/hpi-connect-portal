$(document).ready( function() {
    $('#sign_in_form #username_field').bind('input', function() {
        $('#sign_in_form #url_field').val('https://openid.hpi.uni-potsdam.de/user/' + $(this).val());
    });
});