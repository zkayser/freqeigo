require 'rails_helper'

RSpec.describe UserEnrollment do
  before :each do
    @user = User.new(name: "Zachery L Kayser", 
                     email: "zkays@somewhattokay.com", 
                     password: "password")
    @course = Course.new(title: "Title",
                         summary: "Summary", 
                         level: "Difficult",
                         appx_length: "1 week")
    @enroller = UserEnrollment.new(@user, @course)
  end

  it "Should add a user to course users" do
    @enroller.enroll
    expect(@course.users).to include(@user)
  end
end