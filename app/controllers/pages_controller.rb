class PagesController < ApplicationController
  def front_page
    redirect_to home_path if logged_in?
  end
end
