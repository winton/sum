jQuery(function($) {
  $('form').bind('submit', function() {
    $('#timezone_offset').attr('value', -(new Date()).getTimezoneOffset() * 60);
  });
});