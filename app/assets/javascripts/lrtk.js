$(document).ready(function(){
	$('.picbox').hover(function(){
			$('.og_prev,.og_next').fadeTo('fast',1);
		},function(){
			$('.og_prev,.og_next').fadeTo('fast',0);
	})

    $(function(){
	  $('input:checkbox').click(function () { 
	   this.blur();   
	   this.focus();  
	 });
	 $("#checkpromo").change(function() {
	   $(".cart .view .total .promocode .inputcode").toggle(0);
	 });
	}); 
})

$(function(){ 
  var high=$('.orderstatus .orderlist .fill').css('height');
  var value=parseInt(high); 
  ph = Math.round(value/2) - 40;
  high =(value-ph-1)+"px"
  padding= ph+"px"
  $('.orderstatus .orderlist .fill .right').css('height',high)
  $('.orderstatus .orderlist .fill .right').css('padding-top',padding)
}); 

$(function(){ 
    $(".nav_pro2").click(function(){ 
        $.scrollTo('#navi',700); 
    }); 

}); 

function backtop(){
   document.getElementById('btntop').style.opacity=($(document).scrollTop()/600 - 1)
};

setInterval(backtop,2000)
