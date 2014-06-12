$(window).scroll(function() {
	updateHeader_microsite();
});

/**
 * 
 * @returns {undefined}
 */
function updateHeader_microsite() {
	if($(window).width() > 825) {
		if($(this).scrollTop() > 100){
			$('body').addClass('gt100');
		} else {
			$('body').removeClass('gt100');
		}		
	}
}