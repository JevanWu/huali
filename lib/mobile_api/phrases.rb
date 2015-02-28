module MobileAPI
  class Phrases < Grape::API

    resource :phrases do
     desc "Return a phrase text for today" 
     get :text do
       Phrase.current.text
     end

     desc "Return a phrase image for today"
     get :image do
       Phrasee.current.image
     end
    end
  end
end
