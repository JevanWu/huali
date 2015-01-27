$(document).ready(function(){
  $('.acard').click(function(){
  	$('.card').toggle(500)
  });
  $('.next').click(function(){
  	  $('.tel-error').css('visibility','hidden');
  	  $('.recname-error').css('visibility','hidden');
  	  $('.rectel-error').css('visibility','hidden');
  	  $('.address-error').css('visibility','hidden');
  	  $('.post-error').css('visibility','hidden');
  	  $('.date-error').css('visibility','hidden');
  	  $("#tel").css('border-color','#BFBEBE');
  	  $("#recname").css('border-color','#BFBEBE');
  	  $("#rectel").css('border-color','#BFBEBE');
  	  $("#address").css('border-color','#BFBEBE');
  	  $("#post").css('border-color','#BFBEBE');
  	  $("#date").css('border-color','#BFBEBE');
  	  var pass=true
      var tel=document.getElementById('tel').value
      var recname=document.getElementById('recname').value
      var rectel=document.getElementById('rectel').value
      var address=document.getElementById('address').value
      var post=document.getElementById('post').value
      var date=document.getElementById('date').value
      if(tel==""){
                $('.tel-error').css('visibility','visible');
                pass=false;
                $("#tel").css('border-color','#A02828');
                }
      if(recname==""){
                $('.recname-error').css('visibility','visible');
                pass=false;
                $("#recname").css('border-color','#A02828');
                }
      if(rectel==""){
                $('.rectel-error').css('visibility','visible');
                $("#rectel").css('border-color','#A02828');
                pass=false;
                }
      if(address==""){
                $('.address-error').css('visibility','visible');
                $("#address").css('border-color','#A02828');
                pass=false;
                }
      if(post==""){
                $('.post-error').css('visibility','visible');
                $("#post").css('border-color','#A02828');
                pass=false;
                }
      if(date==""){
                $('.date-error').css('visibility','visible');
                $("#date").css('border-color','#A02828');
                pass=false;
                }
  });

});

