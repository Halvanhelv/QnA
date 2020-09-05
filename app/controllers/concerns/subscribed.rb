module Subscribed
  extend ActiveSupport::Concern

  included do
    before_action :set_subscribable, only: %i[subscribe unsubscribe] # except is the opposite: only

    def subscribe
      authorize! :subscribe, Subscription
      @subscribable.subscriptions.create(user_id: current_user.id)
    end

    def unsubscribe
      authorize! :unsubscribe, set_subscribe
      set_subscribe.destroy
    end

    private

    def set_subscribable
      @subscribable = model_klass.find(params[:id])
    end

    def model_klass
      controller_name.classify.constantize
    end

    def set_subscribe
      @subscription ||= @subscribable.subscriptions.find_by(user_id: current_user)
    end
  end
end
