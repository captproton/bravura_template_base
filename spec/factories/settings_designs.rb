FactoryBot.define do
  factory :settings_design, class: 'Settings::Design' do
    blog_template_gem { 'bravura_template-normal' }
  end
end
