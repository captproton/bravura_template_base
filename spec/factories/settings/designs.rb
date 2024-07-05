# Adjust the factory definitions to reflect the model's structure and requirements
FactoryBot.define do
  # Assuming other related factories (site_mode, blog_theme, etc.) are defined elsewhere
  factory :design, class: 'Settings::Design' do
    association :site_mode
    association :blog_theme
    association :shades_of_gray
    association :button_style
    association :navigation_bar
    association :account
    blog_template_gem { Faker::Internet.domain_word }
  end

  factory :settings do
    design { association :design }
  end
end
