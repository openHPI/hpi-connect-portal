$(document).ready(function($) {
    $(".clickable").click(function() {
        window.document.location = $(this).attr("href");
    });
    $("#submit").click(function(e) {
      alert("hh");
      var category = document.getElementById('category_id')
      var selected_category = category.options[category.selectedIndex]
      var can_book = selected_category.getAttribute('can_book')=="true" ? true : false
      if(!can_book)
      {
        e.preventDefault();
        $('#book_modal').modal('show')
      }         
    });
    $("#book_single").click(function(e) {
        e.preventDefault();
        $("#submit").click()   
    });
});