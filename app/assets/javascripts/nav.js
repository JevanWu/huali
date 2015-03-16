$(document).ready(function(){
    $('.nav li').hover(function(){
        if(!$(".content").is(":animated")){ 
            $(this).children('.nav2').slideDown(50);
          } 
            
        },function(){
          if(!$(".content").is(":animated")){ 
            $(this).children('.nav2').slideUp(50);
          } 
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
    $('#searcha').click(function(){
            $('.nav .nav1 .talk .s').animate({marginLeft:"0",width:"123px"},'fast');
            $('.nav .nav1 .talk .insearch').show(0);
            $('.sarchtext').focus();
    })
    $(".sarchtext").blur(function(){
            $('.nav .nav1 .talk .s').animate({marginLeft:"93px",width:"30px"},'fast');
            
            $('.nav .nav1 .talk .insearch').hide(0);
    })
    $('.popup-trigger').hover(function(){
        $(this).children('.account-menu').slideDown(50);
    },function(){
        $(this).children('.account-menu').slideUp(50);
    })
})
