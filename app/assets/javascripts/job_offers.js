$(document).ready(function($) {
    $(".clickable").click(function() {
        window.document.location = $(this).attr("href");
    });
    var menus = document.getElementById("site_nav").getElementsByTagName("li")
    for(var i = 0; i < menus.length; i++)
    {
      //menus[i].style.box-shadow = "red"
    }
    $("#submit").click(function(e) {
      var category = $('#category_id')
      var selected_category = category.options[category.selectedIndex]
      var can_book = selected_category.getAttribute('can_book')=="true" ? true : false
      if (!can_book) {
        e.preventDefault();
        $('#book_modal').modal('show')
      }
    });
    $("#book_single").click(function(e) {
        $("#submit").click()
    });
});