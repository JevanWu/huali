module MobileAPI
  class Products < Grape::API

    resource :products do
     desc "Return all published products." 
     get do
     end

     desc "Query a product"
     params do
       requires :id, type: Integer, desc: "Product id."
     end
     get ':id' do
       Product.find(params[:id])
     end
    end
  end
end
