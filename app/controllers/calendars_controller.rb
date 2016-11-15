class CalendarsController < ApplicationController
  def edit
  end

  def show
    @user = User.find(params[:user_id])
    @calendar = @user.calendar
  end

  def update
  end

  def destroy
  end
end
