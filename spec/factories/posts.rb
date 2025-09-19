FactoryBot.define do
  factory :post do
    association :user
    body { Faker::Alphanumeric.alphanumeric(number: 50) }
    point { Faker::Number.between(from: 1, to: 10) }
    post_type { :zenkou }

    trait :akugyou do
      point { Faker::Number.between(from: -10, to: -1) }
      post_type { :akugyou }
    end
  end
end
