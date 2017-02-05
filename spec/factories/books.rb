FactoryGirl.define do
  factory :book do
    title { Faker::StarWars.character }
    description { Faker::StarWars.character }
    user_id nil
  end
end