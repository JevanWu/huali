$(function(){ 
    jQuery(".picScroll").slide({ mainCell:"ul", effect:"leftLoop", vis:4, scroll:1, autoPage:true, interTime:5000, autoPlay:true,switchLoad:"_src" });
}); 

$(function(){ 
  jQuery(".js").slide({ titCell:".bor_slide li", mainCell:".main_content", effect:"fold", interTime:5000, delayTime:1000,autoPlay:true});

}); 
$(document).ready(function(){
  $(".nav_pro").click(function(){ 
    $.scrollTo('#newproduct',700); 
  });
}); 
// function nextpage(){
//    document.getElementById('btndown').style.opacity=(1-($(document).scrollTop()/600))
// };

// setInterval(nextpage,100)
