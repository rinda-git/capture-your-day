class WebPushSubscriptionsController < ApplicationController
  before_action :authenticate_user!
  def create
    subscription = WebPushSubscription.find_or_initialize_by(endpoint: params[:endpoint])

    subscription.update!(
      user: current_user,
      p256dh: params[:p256dh],
      auth: params[:auth]
    )

    head :ok
  end
end
