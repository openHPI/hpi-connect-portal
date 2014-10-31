$(document).ready( function() {

    jQuery.fn.extend({
        updateIndex: function(index, newIndex) {
            return this.each(function() {
                $(this).attr('name', $(this).attr('name').replace('[' + index + ']', '[' + newIndex + ']')); 
                if ($(this).attr('id')) $(this).attr('id', $(this).attr('id').replace('_' + index + '_', '_' + newIndex + '_'));
            });
        }
    });

    var markForDeletion = function(element) {
        var container = element.parents('.cv-entry-fields');
        var next = container.next('input');
        if (next.length > 0) {
            var cvEntry = $('<ul class="list-group cv-entry-fields ' + element.data('id').substr(1) + '">');
            var index = next.attr('name').match(/\]\[.*\]\[/g)[0].slice(2,-2);
            next.updateIndex(index, index--);
            var destroyer = next.clone();
            destroyer.attr('id', destroyer.attr('id').replace('id', 'destroy'));
            destroyer.attr('name', destroyer.attr('name').replace('id', '_destroy'));
            destroyer.val('1');
            cvEntry.append(destroyer);
            cvEntry.append(next);
            cvEntry.hide();
            cvEntry.appendTo($('.cv-group' + element.data('id')));
        }
    };
    
    $('.cv-add').click( function(e) {
        e.preventDefault();
        var cv = $('.cv-entry-fields' + $(this).data('id'));
        var newEntry = cv.first().clone();
        
		// remove input values
		newEntry.find('input, textarea, select').each(function() {
            $(this).updateIndex('0', cv.length);
            $(this).val('').removeAttr('checked').removeAttr('selected');
        });
		
		// make all form elements visible
		newEntry.find('li').css('display','');
		
        newEntry.appendTo($('.cv-group' + $(this).data('id')));
    });

    $(document).on('click', '.cv-remove', function(e) {
        e.preventDefault();
        var parent = $(this).parents('.cv-entry-fields');
        if ($('.cv-entry-fields' + $(this).data('id')).length > 1) {
            parent.nextAll('.cv-entry-fields').each(function() {
                var index = $(this).find('input').first().attr('name').match(/\]\[.*\]\[/g)[0].slice(2,-2);
                $(this).find('input, textarea, select').each(function() {
                    $(this).updateIndex(index, index--);
                });
                var next = $(this).next('input');
                if (next.length > 0) next.updateIndex(index, index--);
            });
            markForDeletion($(this));
            parent.remove();
        } else {
            parent.find('input, textarea, select').each(function() {
                $(this).val('').removeAttr('checked').removeAttr('selected');
            });
            markForDeletion($(this));
        }
    });

    $(document).on('change', '.current-item input[type=checkbox]', function() {
        $(this).parents('.current-item').prev('.end-date-item').toggle();
    });
});
