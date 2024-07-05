# factories/accounts.rb
FactoryBot.define do
  factory :account do
    id { Faker::Number.unique.non_zero_digit }
    settings { association :settings }
  end
end
