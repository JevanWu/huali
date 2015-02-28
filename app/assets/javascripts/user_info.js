$(document).ready(function(){
  $(".tab-list li").removeClass(); 
  var userpage=$.cookie("userpage");
  $('#'+userpage).addClass("now")
  $.cookie("userpage", "<%=@partial%>");
});