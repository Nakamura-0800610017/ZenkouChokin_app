FactoryBot.define do
  factory :famous_quote do
    content { Faker::Alphanumeric.alphanumeric(number: 50) }
    author  { Faker::Name.name }
  end
end
