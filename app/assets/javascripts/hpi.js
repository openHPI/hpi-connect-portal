window.onresize = resizepage;
function resizepage () {
    if(!$('body').hasClass('subpage')) {
      if($(window).width()<825){
        if($('.headbottom #social').length==0) {
          if($('#bottom_stuff').length>0) $('#site_nav').after('<div id="bottom_stuff">'+$('#bottom_stuff').html()+'</div>');
          else if($('#social').length>0) $('#site_nav').after('<div id="social">'+$('#social').html()+'</div>');
        } 
        
      } else {
          $('.headbottom #social').remove();
          $('.headbottom #bottom_stuff').remove();
      }
    } else {
      if($(window).width()<500){
        if($('.headbottom #social').length==0) {
          if($('#bottom_stuff').length>0) $('#site_nav').after('<div id="bottom_stuff">'+$('#bottom_stuff').html()+'</div>');
          else if($('#social').length>0) $('#site_nav').after('<div id="social">'+$('#social').html()+'</div>');
        } 
        
      } else {
          $('.headbottom #social').remove();
          $('.headbottom #bottom_stuff').remove();
      }
    }

}

 //initiating jQuery
  jQuery(function($) {
    resizepage ();
    $('.carousel').carousel({
      pause: true,
      interval: false
    });
    $('.collapse').collapse({
      toggle: false,parent:false
    });
   
    $('.collapse').on('show.bs.collapse', function () {
      $(this).parent().addClass('opened');
    });
    $('.collapse').on('hide.bs.collapse', function () {
      $(this).parent().removeClass('opened');
    });
    $('.site_nav').on('mouseover', 'a',function(event) {
      if($(window).width()>840) $(this).click();
    });
    $('.headtop').on('mouseover', function(event) {
      var clicked = $(event.target);
      if(!clicked.hasClass("dropdown-menu") && !clicked.parents().hasClass("dropdown-menu") && !clicked.hasClass("dropdown-toggle")) $('body').click();
    });
    $('.headtop div').on('mouseover', function(event) {
      event.preventDefault();
    });
    $('.submenu').on('mouseleave', function(event) {
      $('body').click();
      $('.site_nav .open').removeClass('open');
    });
   
    $('.site_nav').on('click', 'a',function(event) {
        var cl;
        if($(window).width()>840) {
            cl = $(this).attr('class');
            if(cl!=='') {
              $('.site_nav .open').removeClass('open');
              $('.submenu').hide();
              if($('.submenu.'+cl).length>0) {
                $(this).parent().addClass('open');
                $('.submenu.'+cl).show();
              }
              var pos = $(this).position();
              var top = (pos.top+ $(this).height());
              $('.site_nav').data('open',1);
              $('body').bind('click', function (e) {
                var clicked = $(e.target);
                if (!clicked.hasClass("submenu") && !clicked.parents().hasClass("submenu") && !clicked.parents().hasClass("site_nav")) {
                  $('.submenu').hide();
                  $('.subsubmenu .open').removeClass('open');
                  $('.site_nav .open').removeClass('open');
                  $('body').unbind('click');
                }
              });
            }
        } else {
          cl = $(this).attr('class');
          if($('.submenu.'+cl).length>0) {
            if($(this).next('ul').length===0) $(this).after($('.submenu.'+cl+' div:eq(2)').html());
            else $(this).next('ul').remove();
          } else {
            if($(this).next('ul').length===0) {
              cl = $(this).parent().parent().parent().children('a').attr('class');
              if(cl!==undefined) {
                if($(this).next('ul').length===0) $(this).after('<ul>'+$('.submenu.'+cl+' div:eq(3) ul:eq('+($(this).parent().index()-1)+')').html()+'</ul>');
                event.preventDefault();
              }
            }  else $(this).next('ul').remove();
          }
        }
        event.preventDefault();
        event.stopPropagation();
        return false;
    });

    if($(window).width()>840)  $('.submenuli').on('mouseover', 'li a',function(event) {
      
          var cl = $(this).parents('div.submenu').attr('class').substr(8);
          var i = ($(this).parent().index()-1);
          if(i>=0) {
            var selector = '.submenu.'+cl+' .subsubmenu ul:eq('+i+')';
            $('.submenu.'+cl+' .open').removeClass('open');
            $(this).children('a').addClass('open');
            if($(selector).length>0){
               $(selector).addClass('open');
            }
            $('#site_nav').data('open',2);
          } else $('.submenu.'+cl+' .open').removeClass('open');
        event.stopPropagation();
      });
    
        
  

  $('.close').click(function(event) {
    $(this).parent().css('display','none');
    event.stopPropagation();
    return false;
  });
  $('#filter').click(function(event) {
      if($(this).hasClass('open')) {
        $(this).removeClass('open');
        $('.filters').css('display','none');
      } else {
        $(this).addClass('open');
        $('.filters').css('display','block');
      }
  });

  $('.nav-tabs li:last-child').click(function(event) {
    var pos = $(this).parent().find('.active').index();
    var max = $(this).parent().find('li').length;
    if((pos+2)==max) $(this).parent().find('li:eq(1)').children('a').click();
    else $(this).parent().find('li:eq('+(pos+1)+')').children('a').click();
  });

  $('.nav-tabs li:first-child').click(function(event) {
    var pos = $(this).parent().find('.active').index();
    var max = $(this).parent().find('li').length;
    if(pos==1) $(this).parent().find('li:eq('+ (max-2) +')').children('a').click();
    else $(this).parent().find('li:eq('+(pos-1)+')').children('a').click();
  });

});
  $(window).scroll(function() {
    if($(window).width()>840){
      //console.log($(this).scrollTop());
      if($('body').hasClass('subpage') && $(this).scrollTop()>100) {
        $('.smallheader').show();
        $('.bigheader').hide();
        $('.headbg').css('position','fixed').css('marginTop',-318);
        $('.submenu').css('position','fixed').css('marginTop','-120px');
        $('body').css('marginTop',217);

      } else if(!$('body').hasClass('subpage') && $(this).scrollTop()>100) {
        $('.smallheader').show();
        $('.bigheader').hide();
        $('.headbg').css('position','fixed').css('marginTop',-307);
        $('.submenu').css('position','fixed').css('marginTop','-100px');
        $('body').css('marginTop',207);
      
      } else {
        $('.smallheader').hide();
        $('.bigheader').show();
        $('.headbg').css('position','relative').css('marginTop',0);
        $('body').css('marginTop',0);
        $('body.subpage').css('marginTop',61);
        $('.submenu').css('position','absolute').css('marginTop','0');
      }
    } // end scroll
 });
