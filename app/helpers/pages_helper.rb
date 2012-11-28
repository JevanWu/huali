module PagesHelper
  def choose_payment_method
    banks = ['ICBCB2C', 'CMB', 'CCB', 'BOCB2C', 'ABC', 'COMM', 'CEBBANK', 'SPDB', 'SHBANK']
    render :partial => "choose_payment_method", :locals => { :product => @product, :banks => banks }
  end
end
