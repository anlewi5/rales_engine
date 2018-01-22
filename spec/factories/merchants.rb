FactoryBot.define do
  factory :merchant do
    sequence :name do 
      Faker::Cat.name
    end
  end
end
