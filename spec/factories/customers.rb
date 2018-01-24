FactoryBot.define do
  factory :customer do
    sequence :first_name do 
      Faker::Superhero.prefix
    end
    sequence :last_name do 
      Faker::Superhero.suffix
    end
  end
end
