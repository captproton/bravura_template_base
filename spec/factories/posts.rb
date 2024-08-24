# bravura_template_base/spec/factories/posts.rb
FactoryBot.define do
  factory :post, class: 'Post' do
    association :account
    sequence(:title) { |n| "Post Title #{n}" }
    body { "Post body content" }

    trait :published do
      published_at { 1.day.ago }
    end

    trait :featured do
      featured { true }
    end

    trait :archived do
      archived_at { 1.day.ago }
    end
  end
end
