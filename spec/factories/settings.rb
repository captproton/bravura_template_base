# factories/settings.rb
FactoryBot.define do
  factory :settings do
    design { association :design }
  end
end
