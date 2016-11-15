class UserEnrollment
  
  def initialize(user, course)
    @user = user
    @course = course
  end
  
  def enroll
    @course.users.push(@user)
  end
end