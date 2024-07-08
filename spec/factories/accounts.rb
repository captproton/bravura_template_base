FactoryBot.define do
  factory :account do
    id { Faker::Number.unique.number(digits: 5) }

    trait :with_normal_template do
      after(:build) do |account|
        account.settings.design.blog_template_gem = 'bravura_template_normal'
      end
    end

    trait :with_non_existent_template do
      after(:build) do |account|
        account.settings.design.blog_template_gem = 'non_existent_template'
      end
    end

    after(:build) do |account|
      account.settings ||= OpenStruct.new(design: OpenStruct.new(blog_template_gem: 'bravura_template_normal'))
    end
  end
end
