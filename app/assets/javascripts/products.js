$(document).ready(function(){
  $(".btn-filter").click(function(e){ 
    if ($(".filter").css("display") == 'none')
    {
      $(".filter").slideDown(200);
      
      $(document).click(function(){ 
        $(".filter").slideUp(200);
      e.stopPropagation();
      });
    }
    else
    {
      $(".filter").slideUp(200);
    }
  });
  $(".btn-filter,.filter").on("click", function(e){
    e.stopPropagation();
  });
  $(".type-link,.color-link,.price-link").click(function(){
  	 $(".product-type,.product-color,.product-price").hide(0);
  }); 
  $(".type-link").click(function(){
  	 $(".product-type").show(0);
  }); 
  $(".color-link").click(function(){
  	 $(".product-color").show(0);
  }); 
  $(".price-link").click(function(){
  	 $(".product-price").show(0);
  }); 
});