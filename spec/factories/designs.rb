FactoryBot.define do
  factory :design do
    blog_template_gem { Faker::Lorem.word }
  end
end
