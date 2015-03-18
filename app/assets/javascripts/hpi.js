window.onresize = resizepage;

!function (a) {

    a(function () {

        if (navigator.userAgent.match(/IEMobile\/10\.0/)) {

            var b = document.createElement("style");

            b.appendChild(document.createTextNode("@-ms-viewport{width:auto!important}")), document.querySelector("head").appendChild(b)

        }

        {

            var c = a(window), d = a(document.body);

            a(".navbar").outerHeight(!0) + 10

        }

    })

}(jQuery);
var isSafari = /constructor/i.test(window.HTMLElement);


function resizepage() {
    if(!$('body').hasClass('subpage')) {
        if($(window).width() < 825) {
            if($('.headbottom #social').length == 0) {
                if($('#bottom_stuff').length > 0)
                    $('#site_nav').after('<div id="bottom_stuff">' + $('#bottom_stuff').html() + '</div>');
                else if($('#social').length > 0)
                    $('#site_nav').after('<div id="social">' + $('#social').html() + '</div>');
            }

        } else {
            $('.headbottom #social').remove();
            $('.headbottom #bottom_stuff').remove();
        }
    } else {
        if($(window).width() < 500) {
            if($('.headbottom #social').length == 0) {
                if($('#bottom_stuff').length > 0)
                    $('#site_nav').after('<div id="bottom_stuff">' + $('#bottom_stuff').html() + '</div>');
                else if($('#social').length > 0)
                    $('#site_nav').after('<div id="social">' + $('#social').html() + '</div>');
            }

        } else {
            $('.headbottom #social').remove();
            $('.headbottom #bottom_stuff').remove();
        }
    }
    jQuery('#site_nav li ul').remove();
    updateHeader();
}

//initiating jQuery
jQuery(function($) {
    setPbEvents();
    resizepage();
    /* $('.carousel').carousel({
        pause: true,
        interval: false
    });*/
    $('.collapse').collapse({
        toggle: false, parent: false
    });

    $('.collapse').on('show.bs.collapse', function() {
        $(this).parent().addClass('opened');
        $('#site_nav li ul').remove();
        $('#site_nav li ul li ul').remove();
    });
    $('.collapse').on('hide.bs.collapse', function() {
        $(this).parent().removeClass('opened');
    });
    $('.site_nav').on('mouseover', 'a', function(event) {
        if($(window).width() > 840) {
            var cl = $(this).attr('class');
            if(cl !== '') {
                $('.site_nav .open').removeClass('open');
                $('.submenu').hide();
                if($('.submenu.' + cl).length > 0) {
                    $(this).parent().addClass('open');
                    $('.submenu.' + cl).show();
                }
                var pos = $(this).position();
                var top = (pos.top + $(this).height());
                $('.site_nav').data('open', 1);
            }
        }
    });
    $('.site_nav').on('touchstart', 'a', function(event) {
        if($(window).width() > 840) {
            if(!$(this).parent().hasClass('open')) {
                var cl = $(this).attr('class');
                if(cl !== '') {
                    $('.site_nav .open').removeClass('open');
                    $('.submenu').hide();
                    if($('.submenu.' + cl).length > 0) {
                        $(this).parent().addClass('open');
                        $('.submenu.' + cl).show();
                    }
                    var pos = $(this).position();
                    var top = (pos.top + $(this).height());
                    $('.site_nav').data('open', 1);
                }
                return false;
            }
            else
                $(this).click();
        }
    });
    $('.submenu').on('touchstart', 'a', function(event) {
        if($(window).width() > 840) {
            if(!$(this).hasClass('open')) {
                $('.submenu .open, .subsubmenu .open').removeClass('open');
                $(this).addClass('open');
                $('.subsubmenu div[data-uid="' + $(this).parent().attr('data-uid') + '"] ul').addClass('open');
                return false;
            }
            else
                $(this).click();
        }
    });
    $('.headtop').on('mouseenter', function() {
        $('.submenu').hide();
        $('.subsubmenu .open').removeClass('open');
        $('.site_nav .open').removeClass('open');
    });
    $('.hideSubmenuMouseOver').on('mouseenter', function() {
        $('.submenu').hide();
        $('.subsubmenu .open').removeClass('open');
        $('.site_nav .open').removeClass('open');
    });
    $('.search').on('mouseenter', function() {
        $('.submenu').hide();
        $('.subsubmenu .open').removeClass('open');
        $('.site_nav .open').removeClass('open');
    });
//  $('.site_nav').on('mouseleave', 'a', function(event) {
//      var cl = $(this).attr('class');
//      if($('.submenu.' + cl).length > 0) {
//          if($('.submenu.' + cl + ':hover').length == 0) {
//              $('.submenu').hide();
//              $('.subsubmenu .open').removeClass('open');
//              $('.site_nav .open').removeClass('open');
//          }
//      }
//  });
    $('.headtop').on('mouseover', function(event) {
        var clicked = $(event.target);
        if(!clicked.hasClass("dropdown-menu") && !clicked.parents().hasClass("dropdown-menu") && !clicked.hasClass("dropdown-toggle"))
            $('body').click();
    });
    $('.headtop div').on('mouseover', function(event) {
        event.preventDefault();
    });
    $('.submenu').on('mouseleave', function(event) {
        $('.submenu').hide();
        $('.subsubmenu .open').removeClass('open');
        $('.site_nav .open').removeClass('open');
    });

    $('.site_nav').on('click', 'a', function(event) {
        var cl;
        if($(window).width() <= 840) {
            cl = $(this).attr('class');
            if($('.submenu.' + cl).length > 0) {
                if($(this).next('ul').length === 0) {
                    $('#site_nav li ul').remove();
                    $(this).after($('.submenu.' + cl + ' div:eq(2)').html());
                    event.preventDefault();
                    event.stopPropagation();
                    return false;
                }
//              else
//                  $(this).next('ul').remove();
            } else {
                if($(this).next('ul').length === 0) {
                    cl = $(this).parent().parent().parent().children('a').attr('class');
                    if(cl !== undefined) {
                        if($(this).next('ul').length === 0) {
                            var submenu = $('.submenu.' + cl + ' div[data-uid=' + $(this).parent('li').attr('data-uid') + '] ul');
                            if(submenu.length > 0 && !submenu.is(':visible')) {
                                $('#site_nav li ul li ul').remove();
                                $(this).after('<ul>' + submenu.html() + '</ul>');
                                event.preventDefault();
                                event.stopPropagation();
                                return false;
                            }
                        }
                    }
                }
//              else
//                  $(this).next('ul').remove();
            }

        }
    });

    $('.site_nav').on('touchstart', 'a', function(event) {
        $('body').bind('click', function(e) {
            var clicked = $(e.target);
            if(!clicked.hasClass("submenu") && !clicked.parents().hasClass("submenu") && !clicked.parents().hasClass("site_nav")) {
                $('.submenu').hide();
                $('.subsubmenu .open').removeClass('open');
                $('.site_nav .open').removeClass('open');
                $('body').unbind('click');
            }
        });
//      cl = $(this).attr('class');
//      if(cl !== '') {
//          $('.site_nav .open').removeClass('open');
//          $('.submenu').hide();
//          if($('.submenu.' + cl).length > 0) {
//              $(this).parent().addClass('open');
//              $('.submenu.' + cl).show();
//          }
//          var pos = $(this).position();
//          var top = (pos.top + $(this).height());
//          $('.site_nav').data('open', 1);
//
//      }
//      event.preventDefault();
//      event.stopPropagation();
//      return false;
    });

    if($(window).width() > 840) {
        $('.submenuli').on('mouseover', 'li a', function(event) {
            var cl = $(this).parents('div.submenu').attr('class').substr(8);
            //var i = ($(this).parent().index() - 1);
//          if(i >= 0) {
            var selector = '.submenu.' + cl + ' .subsubmenu div[data-uid=' + $(this).parent('li').attr('data-uid') + '] ul';
            $('.submenu.' + cl + ' .open').removeClass('open');
            $(this).children('a').addClass('open');
            if($(selector).length > 0) {
                $(selector).addClass('open');
            }
            $('#site_nav').data('open', 2);
//          } else
//              $('.submenu.' + cl + ' .open').removeClass('open');
            event.stopPropagation();
        });
    }

    $('.closeX').click(function(event) {
        $(this).parent().css('display', 'none');
        event.stopPropagation();
        return false;
    });
    $('#filter').click(function(event) {
        if($(this).hasClass('open')) {
            $(this).removeClass('open');
            $('.filters').css('display', 'none');
        } else {
            $(this).addClass('open');
            $('.filters').css('display', 'block');
        }
    });

    $('.nav-tabs li:last-child').click(function(event) {
        var pos = $(this).parent().find('.active').index();
        var max = $(this).parent().find('li').length;
        if((pos + 2) == max)
            $(this).parent().find('li:eq(1)').children('a').click();
        else
            $(this).parent().find('li:eq(' + (pos + 1) + ')').children('a').click();
    });

    $('.nav-tabs li:first-child').click(function(event) {
        var pos = $(this).parent().find('.active').index();
        var max = $(this).parent().find('li').length;
        if(pos == 1)
            $(this).parent().find('li:eq(' + (max - 2) + ')').children('a').click();
        else
            $(this).parent().find('li:eq(' + (pos - 1) + ')').children('a').click();
    });

    var colorbox_settings = {
        current: "Bild {current} von {total}",
        previous: "Zurück",
        next: "Vor",
        close: "Schließen",
        xhrError: "Dieser Inhalt konnte nicht geladen werden.",
        imgError: "Dieses Bild konnte nicht geladen werden.",
        slideshowStart: "Slideshow starten",
        slideshowStop: "Slideshow anhalten",
        maxWidth: '95%',
        maxHeight: '95%',

        title: function() {
            var title = $(this).children('img').attr('data-caption');
            if(title == undefined)
                title = '';
            else
                title = '<p>' + title + '</p>';
            return title;
        }
    }
    jQuery('.csc-textpic').each(function(index, item) {
        item = jQuery(item);
        if(item.find('.pics3view').size() > 0) {
            item.find('a').colorbox(colorbox_settings);
        }

    });
    /*  jQuery.extend(jQuery.colorbox.settings, {
     current: "Bild {current} von {total}",
     previous: "Zurück",
     next: "Vor",
     close: "Schließen",
     xhrError: "Dieser Inhalt konnte nicht geladen werden.",
     imgError: "Dieses Bild konnte nicht geladen werden.",
     slideshowStart: "Slideshow starten",
     slideshowStop: "Slideshow anhalten"
     });*/

    // Resize Colorbox when resizing window or changing mobile device orientation
    $(window).resize(function() {
        resizeColorBox(colorbox_settings);
    });
    //window.addEventListener('orientationchange', resizeColorBox, false);

});
$(window).scroll(function() {
    updateHeader();
});

/* Colorbox resize function */
function resizeColorBox(colorbox_settings) {
    $.colorbox.resize({
        width: window.innerWidth > parseInt(colorbox_settings.maxWidth) ? colorbox_settings.maxWidth : colorbox_settings.width,
        height: window.innerHeight > parseInt(colorbox_settings.maxHeight) ? colorbox_settings.maxHeight : colorbox_settings.height
     });
//  if(resizeTimer)
//      clearTimeout(resizeTimer);
//  resizeTimer = setTimeout(function() {
//      if(jQuery('#cboxOverlay').is(':visible')) {
//          jQuery.colorbox.resize({width:'90%', height:'90%'});
//      }
//  }, 300)
}

/**
 * 
 * @returns {undefined}
 */
function updateHeader() {
    var $element = $.colorbox.element();
    var i = 1;
    //console.info('scrolling:'+$(this).scrollTop());
    $('#content .csc-textpic.csc-textpic-center.csc-textpic-above').each(function() {
        var parent = $(this).parents('.col-md-8');
        var padding = parseInt($(parent).css('padding-left')) + parseInt($(parent).css('padding-right')) + parseInt($(parent).css('margin-right'));
        width = $('.pics3view:eq(0)', this).outerWidth(true);
        var anz = parseInt(($('#content').innerWidth() - padding) / width);
        if($(this).parents('.imageGallery').length) {
            var length = $('.pics3view', this).length;
        } else {
            var length = $('.pics3view:not(.gt3)', this).length;
        }
        if(length < anz) {
            anz = length;
        }
        $(parent).addClass('ttt')
        $(this).innerWidth(width * anz).css('margin-left', ($('#content').innerWidth() - padding - width * anz) / 2);
    });
    if($(window).width() > 825) {
        if(($('body').hasClass('subpage') && $(this).scrollTop() > 100)) {
            $('.smallheader').show();
            $('.bigheader').hide();
            $('.headbg').css('position', 'fixed').css('marginTop', -318);
            $('.submenu').css('position', 'fixed').css('marginTop', '-120px');
            $('body').css('marginTop', 260);
        } else if(!$('body').hasClass('subpage') && $(this).scrollTop() > 100) {
            $('.smallheader').show();
            $('.bigheader').hide();
            $('.headbg').css('position', 'fixed').css('marginTop', -307);
            $('.submen.su').css('position', 'fixed').css('marginTop', '-100px');
            $('body').css('marginTop', 207);
        } else {
            $('.smallheader').hide();
            $('.bigheader').show();
            $('.headbg').css('position', 'relative').css('marginTop', 0);
            $('body').css('marginTop', 0);
            $('body.subpage').css('marginTop', 61);
            $('.submenu').css('position', 'absolute').css('marginTop', '0');
            if(isSafari){
                $('.headbg').hide();
                $('.headbg').get(0).offsetHeight; // no need to store this anywhere, the reference is enough
                $('.headbg').show();
            }
        }
    }
    else {
        //console.info('D');
        $('.smallheader').show();
        $('.bigheader').hide();
        $('.headbg').css('position', 'fixed').css('marginTop', 0);
        $('.submenu').css('position', 'fixed').css('marginTop', 0);
        $('body').css('marginTop', '98px');
    }
}

function setPbEvents() {
    jQuery('.teaser.newsarchiv').each(function(index, item) {
        var parentOverview = jQuery(item);

        parentOverview.find('.tx_dscoverview_pbLink.page, .tx_dscoverview_pbLink.prev, .tx_dscoverview_pbLink.next').each(function(index2, item2) {
            jQuery(item2).unbind('click');
            jQuery(item2).click(function() {
                if(jQuery(this).hasClass('active')) {
                    jQuery('.tx_dscoverview_pbLink.page').removeClass('current');
                    var limitItemsOffset = jQuery(this).attr('data-value');
                    jQuery(this).addClass('current');
                    parentOverview.find('.tx_dscoverview_limitItemsOffset').val(limitItemsOffset);
                    parentOverview.find('.tx_dscoverview_pbForm').submit();
                }
            });
        });

        parentOverview.find('.tx_dscoverview_pbLink.amount').each(function(index2, item2) {
            jQuery(item2).unbind('click');
            jQuery(item2).click(function() {
                jQuery('.tx_dscoverview_pbLink.amount').removeClass('current');
                jQuery(this).addClass('current');
                parentOverview.find('.tx_dscoverview_limitItemsLength').val(jQuery(this).attr('data-value'));
                parentOverview.find('.tx_dscoverview_pbForm').submit();
            });
        });
    });
}
