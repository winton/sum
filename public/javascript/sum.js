jQuery(function($) {
  $('form').bind('submit', function() {
    $('#timezone_offset').attr('value', -(new Date()).getTimezoneOffset() * 60);
  });
  $('*[rel*=facebox]').facebox({
    closeImage: '/image/facebox/closelabel.gif',
    loadingImage: '/image/facebox/loading.gif'
  });
});