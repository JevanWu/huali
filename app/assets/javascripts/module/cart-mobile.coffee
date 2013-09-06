$ ->
  #cart-mobile.html 编辑物品
  $(".cart-product-list li").each (i,el) ->
    new window.Huali.component.GoodsEditMobile
      node: $(this)
    return
  
  return