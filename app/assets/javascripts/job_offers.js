$(document).ready(function($) {
	$('select').change(function(){
       //var selected = $(this).find('option:selected');
       //alert(extra);
       //alert(selected);
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
	function CheckForAllowedCategory(category)
	{
		//alert(category);
	};