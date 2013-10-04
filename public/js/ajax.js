// for x-editable
$.fn.editable.defaults.mode = 'inline';
$(document).ready(function() {
  var el = $(this);
  $('.ui-state-default').editable({
  	type: 'text',
  	pk: el.data('id'),
  	value: el.data('text'),
  });
});

// for delete
$(function(){
  $('.deleteCmd').click(function(){
    var el = $(this).parent();
    $.post('/delete', {
      id: el.data('id')
    }, function() {
      el.fadeOut(800)
    });
    return false;
  })
});

// for sortable
$(function(){
  $('#sortable-li').sortable({
    handle: '.ui-icon',
    update: function(event, ui){
      var ids = $('#sortable-li').sortable('toArray');
      $.post('/sort',{ids: ids});
    }
  });
});

// for post
$(function(){
  $(".addCmd").click(function(){
    $.post('/new', {
      body: $("#body").val()
    }, function(res) {
      resobj = JSON.parse(res);
      $("#sortable-li").prepend(
        $("<li>").attr({'data-id':resobj.id, id:resobj.id}).append(
          $("<a>").attr({href:'#', id:resobj.id, class:'ui-state-default', 'data-pk': resobj.id, 'data-name':'task', 'data-type':'text', 'data-url':'/edit', 'data-title':'enter'}).text(resobj.body)
          ,$("<span>").attr({class:'ui-icon ui-icon-trash deleteCmd'}).text('')
          ,$('<span>').attr({class:'ui-icon ui-icon-arrowthick-2-n-s ui-corner-all ui-state-hover moveCmd'}).text(' ')
        )
      );
    });
    $("#body").val("");
    return false;
  });
});
