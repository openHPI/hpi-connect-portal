$('.filters input[type=checkbox]').change(function() {
	$(this).closest('form').submit();
});
$('img').removeAttr('width').removeAttr('height');