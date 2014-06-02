$(document).ready(function($) {
	$('#category_id').change(function(){
       //var selected = $(this).find('option:selected');
       //hasAttribute

       	var category = document.getElementById('category_id')
       	var selected_category = category.options[category.selectedIndex]
       	var can_book = selected_category.getAttribute('can_book')=="true" ? true : false
    	if(!can_book)
    	{
       		$('#book_modal').modal
       		$('#book_modal').modal('show')
		}       	
    });
    $(".clickable").click(function() {
        window.document.location = $(this).attr("href");
    });
});