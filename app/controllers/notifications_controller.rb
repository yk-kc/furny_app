class NotificationsController < ApplicationController
  after_action :update_notifications, only: [:index]

  def index
    @notifications = current_user.passive_notifications.page(params[:page]).per(20)
  end

  private

  def update_notifications
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
  end

end
