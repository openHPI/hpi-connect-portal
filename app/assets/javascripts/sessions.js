$(document).ready( function() {

    var currentLanguage = $("ul[class='lang_switcher']").find("span:not(:has(a))").text();
    var activeLink;
    if(window.location.href.substr(window.location.href.length-2, window.location.href.length)==currentLanguage) {
        activeLink = $("#site_nav a[href='/" + currentLanguage + "']");
    }
    else {
        var ArraySites = new Array('job_offers', 'students', 'staff', 'employers', 'admin/configurable')
        for(var i = 0; i < ArraySites.length; i++) {
            if(window.location.href.indexOf('/' + currentLanguage + '/' + ArraySites[i])!=-1) {
            activeLink = $("#site_nav a[href='/" + currentLanguage + "/" + ArraySites[i] + "']");
            break;
            }
        }

    }
    activeLink.attr("class", "theme3")
    activeLink.parent().attr("class", "active")
	
    $('#sign_in_form #username_field').bind('input', function() {
        $('#sign_in_form #url_field').val('https://openid.hpi.uni-potsdam.de/user/' + $(this).val());
    });
});