FactoryBot.define do
  factory :account do
    sequence(:subdomain) { |n| "testblog#{n}" }
    sequence(:name) { |n| "Test Blog #{n}" }
    status { 'active' }

    trait :with_blog_settings do
      transient do
        blog_title { 'My Awesome Blog' }
        posts_per_page { 10 }
      end

      after(:create) do |account, evaluator|
        account.instance_variable_set(:@blog_title, evaluator.blog_title)
        account.instance_variable_set(:@posts_per_page, evaluator.posts_per_page)

        def account.blog_title
          @blog_title
        end

        def account.posts_per_page
          @posts_per_page
        end
      end
    end

    trait :with_prime_template do
      after(:build) do |account|
        account.settings = OpenStruct.new(
          design: Settings::Design.new(blog_template_gem: 'bravura_template_prime')
        )
      end
    end

    trait :with_normal_template do
      after(:build) do |account|
        account.settings = OpenStruct.new(
          design: Settings::Design.new(blog_template_gem: 'bravura_template_normal')
        )
      end
    end

    trait :with_non_existent_template do
      after(:build) do |account|
        account.settings = OpenStruct.new(
          design: Settings::Design.new(blog_template_gem: 'non_existent_template')
        )
      end
    end
  end
end
