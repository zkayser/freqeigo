class EnrollmentsController < ApplicationController
  before_action :set_course
  
  def enroll
    unless current_user.nil?
      @user = current_user
      enrollment = UserEnrollment.new(@user, @course)
      if enrollment.enroll
        flash[:notice] = "Welcome to class."
        redirect_to course_path(@course)
      else
        render courses_path
      end
    else
      flash[:warning] = "You must be logged in to enroll."
      redirect_to courses_path
    end
  end
  
  private
  # Before actions
  def set_course
    @course = Course.find(params[:course_id])
  end
end
