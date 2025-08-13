class HomeController < ApplicationController
  allow_unauthenticated_access only: [ :index ]

  def index
  end

  def dashboard
    add_breadcrumb "Dashboard", dashboard_path, active: true
    @user_count = User.count
    @character_count = Character.count
  end
end
