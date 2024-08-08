module BravuraTemplateBase
  module ApplicationControllerConcern
    extend ActiveSupport::Concern

    included do
      before_action :set_view_strategy
    end

    private

    def set_view_strategy
      settings = BravuraTemplateBase::GuaranteedSettingService.for_account(ActsAsTenant.current_tenant)
      @view_strategy = BravuraTemplateBase::ViewStrategyFactory.create(settings, account: current_account)
    end
  end
end
