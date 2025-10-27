FactoryBot.define do
  factory :bookmark do
    association :user
    association :post
    session_id { nil }

    trait :guest do
      user { nil }
      session_id { SecureRandom.uuid }
    end
  end
end
