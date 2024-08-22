# spec/support/mocks/account.rb
class Account
  attr_accessor :subdomain, :name

  def initialize(attributes = {})
    @subdomain = attributes[:subdomain] || 'test'
    @name = attributes[:name] || 'Test Account'
  end
end
