FactoryBot.define do
  factory :account do
    id { Faker::Number.unique.number(digits: 5) }

    trait :with_normal_template do
      after(:build) do |account|
        # Ensure settings_design is initialized before setting blog_template_gem
        account.settings_design ||= OpenStruct.new
        account.settings_design.blog_template_gem = 'bravura_template_normal'
      end
    end

    trait :with_non_existent_template do
      after(:build) do |account|
        # Ensure settings_design is initialized before setting blog_template_gem
        account.settings_design ||= OpenStruct.new
        account.settings_design.blog_template_gem = 'non_existent_template'
      end
    end

    after(:build) do |account|
      # If settings_design should be the default, adjust this block accordingly
      account.settings_design ||= OpenStruct.new(blog_template_gem: 'bravura_template_normal')
    end
  end
end
