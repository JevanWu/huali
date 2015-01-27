
$(document).ready(function(){
  $('.prebrands').click(function(){
  	$('.brands1').slideDown(500)
	$('.brands2').slideUp(500)
	$('.prebrands').toggle(0)
	$('.nextbrands').toggle(0)
  });

  $('.nextbrands').click(function(){
	$('.brands1').slideUp(500)
	$('.brands2').slideDown(500)
	$('.prebrands').toggle(0)
	$('.nextbrands').toggle(0)
  });
});

