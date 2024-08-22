# spec/support/mocks/current_helper.rb
module CurrentHelper
  def current_account
    Current.account
  end

  def current_account_user
    @account_user ||= double('AccountUser', active_roles: [], admin?: false)
  end

  def current_roles
    []
  end

  def current_account_admin?
    false
  end

  def other_accounts
    []
  end
end
