module MobileAPI
  class DailyPhrases < Grape::API

    resource :daily_phrase do
     desc "Return the last daily phrase." 
     get do
       phrase = DailyPhrase.last
       error!('no phrase exists for now!', 404) if !phrase.present?
       { title: phrase.title, phrase: phrase.phrase, image: "#{phrase.image ? phrase.image.url : "/"}"}
     end
    end
  end
end
