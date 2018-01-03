// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui/widgets/datepicker
//= require jquery.turbolinks
//= require jquery-star-rating
//= require jquery.raty.min
//= require tinymce-jquery
//= require bootstrap/bootstrap
//= require_tree .


$(document).ready( function() {
  $('.dropdown-toggle').dropdown();

  tinymce.baseURL = '/connect/jobportal/assets/tinymce'; 

  $('div.employer_rating_stars').raty({
    score: function() {
      if ($(this).attr('data-score')){
        return $(this).attr('data-score');
      }
    },
    readOnly: true
  });


  $('div.rating_form_field').each(function(){

    var tid = '#'+ $(this).attr('data-target');

    $(this).raty({
        score: function() {

          var input_value = $(tid).val();

          if (!( isNaN(input_value) || (! input_value)))
          {
            return input_value;
          }
          else
          {
             $(tid).removeAttr('value')
          }
        },
        target: tid,
        cancel: true,
        targetKeep: true,
        targetScore: tid,
        targetType  : 'number'
    });
  });

  $('#employers_carousel .item').first().addClass("active");

  $('#employers_carousel').carousel({
    interval: 4000,
    pause: "hover"
  });

  $('#job_offer_preview_button').click(function() {

    var job_offer_title = jQuery('.job_offer_title input').val();
    var job_offer_description = tinymce.activeEditor.getContent();

    $('#job_offer_preview_modal').find(".modal-title").text(job_offer_title);
    $('#job_offer_preview_modal').find(".modal-body").html(job_offer_description);
    $('#job_offer_preview_modal').modal('show');
  });

});

$(function() {
    $(".datepicker").datepicker({
        dateFormat: 'dd-mm-yy'
    });
});

$(function() {
    $('.field_with_errors').addClass('form-group has-error');
});

$(function() {
    $('#error_explanation').addClass('alert alert-danger block-message');
});

$(function(){
    var caret = ' <span style="font-size:0.7em" class="glyphicon glyphicon-chevron-right"><span>';
    $("[data-toggle=collapse]").parent().on('show.bs.collapse', function () {
        console.debug(this)
        $("h4 span.glyphicon-chevron-right", this).removeClass("glyphicon-chevron-right").addClass("glyphicon-chevron-down");
    });
    $("[data-toggle=collapse]").parent().on('hide.bs.collapse', function () {
        $("h4 span.glyphicon-chevron-down", this).removeClass("glyphicon-chevron-down").addClass("glyphicon-chevron-right");
    });
    $("[data-toggle=collapse] h4").append(caret);
});
