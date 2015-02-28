$(document).ready(function(){
  $(".tab-list li").removeClass(); 
  var userpage=$.cookie("userpage");
  if (userpage !== "<%=@partial%>")
  {
    $('#'+userpage).addClass("now")
   }
});