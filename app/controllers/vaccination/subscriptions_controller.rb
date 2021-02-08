class Vaccination::SubscriptionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @subscriptions = get_subscriptions

    fresh_when(@subscriptions, public: false)
  end

  def create
    @subscription = VaccinationSubscription.create_or_find_by!(subscription_params)

    @subscriptions = get_subscriptions

    respond_to do |format|
      if @subscription.save
        format.json { render :index, status: :created }
      else
        format.json { render json: { errors: @subscription.errors }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @subscription = VaccinationSubscription.find(params[:id])
    @subscription.destroy

    @subscriptions = get_subscriptions

    respond_to do |format|
      format.json { render :index, status: :ok }
    end
  end

  private

  def get_subscriptions
    VaccinationSubscription
      .where(
        channel: channel,
        user_id: user_id,
      )
  end

  def user_id
    params[:user_id]
  end

  def channel
    params[:channel]
  end

  def subscription_params
    params.require(:subscription).permit(:channel, :user_id, :region_id)
  end
end
