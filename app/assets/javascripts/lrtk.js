

$(document).ready(function(){
	$('.picbox').hover(function(){
			$('.og_prev,.og_next').fadeTo('fast',1);
		},function(){
			$('.og_prev,.og_next').fadeTo('fast',0);
	})
    $('.popup-trigger').hover(function(){
            $('.account-menu').slideDown('fast');
        },function(){
            $('.account-menu').slideUp('fast');
    })
    $('.nav li').hover(function(){
            var Y = $(this).children('a').offset().left;
            $(this).children('.sub').css('left',Y)
            $(this).children('.sub,.nav4').slideDown('fast');
            $(this).children('.or').css('color','#F7BC7C');
            $(this).children('.up').css('display','inline-block')
            $(this).children('.down').css('display','none')
        },function(){
            $(this).children('.sub,.nav4').slideUp('fast');
            $(this).children('.or').css('color','black');
            $(this).children('.up').css('display','none')
            $(this).children('.down').css('display','inline-block')
    })
    $('.nav1-li').hover(function(){
            $(this).children('.nav2').slideDown('fast');
        },function(){
            $(this).children('.nav2').slideUp('fast');

    })
    $('#searcha').click(function(){
            $('.nav .nav1 .talk .s').animate({marginLeft:"0",width:"123px"},'fast');
            $('.nav .nav1 .talk .insearch').show(0);
            $('.sarchtext').focus();
    })
    $(".sarchtext").blur(function(){
            $('.nav .nav1 .talk .s').animate({marginLeft:"93px",width:"30px"},'fast');
            
            $('.nav .nav1 .talk .insearch').hide(0);
    })

    $(function(){
	 if ($.browser.msie) {
	  $('input:checkbox').click(function () { 
	   this.blur();   
	   this.focus(); 
	  });   
	 };
	 $("#checkpromo").change(function() {
	   $(".cart .view .total .promocode .inputcode").toggle('fast');
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
