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
//= require jquery.ui.datepicker
//= require jquery.turbolinks
//= require jquery-star-rating
//= require tinymce-jquery
//= 
//= require bootstrap/bootstrap
//= require_tree .


$(document).ready( function() {
    $('.dropdown-toggle').dropdown();
	
	var language = window.locale === 'de' ? 'de' : 'en';
	
	$('textarea.tinymce').tinymce({
            relative_urls : true,
            document_base_url: "http://localhost:3000/assets/tinymce/",
			language : language,
		    plugins: [
		        "advlist autolink lists link image preview anchor",
		        "searchreplace visualblocks code",
		        "insertdatetime table contextmenu paste textcolor"
		    ],
			menubar: "table format view insert edit",
		    toolbar: "undo redo | styleselect | bold italic | forecolor backcolor | alignleft aligncenter alignright | bullist outdent indent | link | code"
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
