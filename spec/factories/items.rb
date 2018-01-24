FactoryBot.define do
  factory :item do
    sequence :name do 
      Faker::GameOfThrones.character
    end
    sequence :description do
      Faker::GameOfThrones.house
    end
    sequence :unit_price do
      rand(100..500)
    end
    merchant
  end
end
