jQuery(function($) {
  $('form').bind('submit', function() {
    $('<input name="user[timezone_offset]" type="hidden" value="' + -(new Date()).getTimezoneOffset() * 60 + '" />')
      .appendTo(this);
  });
});