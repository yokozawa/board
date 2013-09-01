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
$('.deleteCmd').click(function(){
  var el = $(this).parent();
  $.post('/delete', {
    id: el.data('id')
  }, function() {
    el.fadeOut(800)
  });
  return false;
})

// for sortable
$(function(){
  $('#sortable-li').sortable({
    update: function(event, ui){
      var ids = $('#sortable-li').sortable('toArray');
      $.post('/sort',{ids: ids});
    }
  });
});