class ApplicationController < ActionController::Base
  include Authentication
  include BreadcrumbHelper
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_common_breadcrumbs

  private

  def set_common_breadcrumbs
    add_breadcrumb "Home", root_path
  end
end
