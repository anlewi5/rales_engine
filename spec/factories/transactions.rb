FactoryBot.define do
  factory :transaction do
    sequence :credit_card_number do 
      Faker::Number.number(16) 
    end
    
    sequence :result do 
      ["success", "failed"].sample
    end

    invoice 
   
  end
end
