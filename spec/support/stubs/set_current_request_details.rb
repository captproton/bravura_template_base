# spec/support/stubs/set_current_request_details.rb
module SetCurrentRequestDetails
  extend ActiveSupport::Concern

  included do |base|
    if base < ActionController::Base
      before_action :set_request_details
    end
  end

  def set_request_details
    Current.request_id = 'test-request-id'
    Current.user_agent = 'test-user-agent'
    Current.ip_address = '127.0.0.1'
    Current.user = current_user
    Current.account = current_account
  end

  def current_account
    @current_account ||= Account.find_by(id: params[:account_id]) || Account.first
  end
end
