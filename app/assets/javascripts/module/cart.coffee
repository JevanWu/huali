$ ->
  #cart.html 编辑物品
  $(".cart-product-item").each (i,el) ->
    new window.Huali.component.GoodsEdit
      node: $(this)
    return
  

  return