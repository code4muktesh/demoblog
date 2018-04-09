class AdminController < ApplicationController
  before_filter :authenticate_user!, only: [:index]
  before_filter :check_role_autorization
  def index
  end
end
