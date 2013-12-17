$(document).ready( function() {
    console.log('ready');
    $('#sign_in_form #username_field').bind('input', function() {
        console.log('input');
        $('#sign_in_form #url_field').val('https://openid.hpi.uni-potsdam.de/user/' + $(this).val());
    });
});