$(document).ready(function(){
$('.account-setting-link').click(function(){
        $('#account-setting').addClass('now')
        $('#order').removeClass('now')
        $('#hua-point').removeClass('now')
        $('#invite').removeClass('now')
        $('.account-setting').show(0)
        $('.order').hide(0)
        $('.hua-point').hide(0)
        $('.invite').hide(0)

})
$('.order-link').click(function(){
        $('#account-setting').removeClass('now')
        $('#order').addClass('now')
        $('#hua-point').removeClass('now')
        $('#invite').removeClass('now')
        $('.account-setting').hide(0)
        $('.order').show(0)
        $('.hua-point').hide(0)
        $('.invite').hide(0)
})
$('.hua-point-link').click(function(){
        $('#account-setting').removeClass('now')
        $('#order').removeClass('now')
        $('#hua-point').addClass('now')
        $('#invite').removeClass('now')
        $('.account-setting').hide(0)
        $('.order').hide(0)
        $('.hua-point').show(0)
        $('.invite').hide(0)
})
$('.invite-link').click(function(){
        $('#account-setting').removeClass('now')
        $('#order').removeClass('now')
        $('#hua-point').removeClass('now')
        $('#invite').addClass('now')
        $('.account-setting').hide(0)
        $('.order').hide(0)
        $('.hua-point').hide(0)
        $('.invite').show(0)
})
}); 

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
