$(document).ready(function(){
  $(".btn-filter").click(function(e){ 
    if ($(".filter").css("display") == 'none')
    {
      $(".filter").slideDown(200);
    }
    else
    {
      $(".filter").slideUp(200);
    }
  });

});