FactoryBot.define do
  factory :user_point do
    association :user
    total_points { 24 }
    user_rank { :normal }

    trait :danka do
      total_points { 25 }
      user_rank { :danka }
    end

  end
end
