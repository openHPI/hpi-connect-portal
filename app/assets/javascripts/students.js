  
$(function() {

  //takes the id of the chosen student and sets it in the dialog
  $(document).on("click", ".change-role", function () {
     var student_id = $(this).data('id');
     $("#student_id").val( student_id );
   });

  //when the role of a student is changed to Admin, the drop-down menu with the different chairs is not visible
  $("#role_name").change(function(event){
    if(event.target.value == "Admin"){
      $("#chair_name").css('visibility', 'hidden')
    }
    else {
      $("#chair_name").css('visibility', 'visible')
    }
  });
})
