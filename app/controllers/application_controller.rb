class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, if: -> { request.inertia? }

  inertia_share flash: -> {
    {
      message: flash.notice,
      alert: flash.alert
    }
  }
end
