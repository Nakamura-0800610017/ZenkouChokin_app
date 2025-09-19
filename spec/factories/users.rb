FactoryBot.define do
  factory :user do
    user_name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password { "password" }
    password_confirmation { "password" }
    terms_of_service { true }
    mode { :normal }
    role { :general }

    trait :focus do
      mode { :focus }
    end

    trait :admin do
      role { :admin }
    end
  end
end
