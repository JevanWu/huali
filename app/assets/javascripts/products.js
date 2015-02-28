$(document).ready(function(){
  var filtershow=$.cookie("filter");
  if (filtershow == 0)
  {
    $(".filter").slideUp(0);
  }
  else
  {
    $(".filter").slideDown(0);
  }


  $(".btn-filter").click(function(e){ 
    if ($(".filter").css("display") == 'none')
    {
      $(".filter").slideDown(200);
      $.cookie("filter", "1"); 
      $(document).click(function(){ 
        $(".filter").slideUp(200);
        e.stopPropagation();
        $.cookie("filter", "0");
      });

    }
    else
    {
      $(".filter").slideUp(200);
      $.cookie("filter", "0"); 
    }
  });
   $(".btn-filter,.filter").on("click", function(e){
     e.stopPropagation();
   });
  $(document).click(function(){ 
    $(".filter").slideUp(200);
    e.stopPropagation();
    $.cookie("filter", "0");
  });
  $(".btn-filter,.filter").on("click", function(e){
     e.stopPropagation();
   });
});