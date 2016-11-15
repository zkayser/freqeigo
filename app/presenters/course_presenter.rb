class CoursePresenter < ModelPresenter
  delegate :params, :link_to, :current_user, :course_path, :user_enrollment_path, to: :view_context
  
  def course_list(level)
    case level
      when "Beginner"
        courses = Course.beginner.all.to_a if Course.beginner.any?
      when "Medium"
        courses = Course.beginner.all.to_a if Course.medium.any?
      when "Advanced"
        courses = Course.beginner.all.to_a if Course.advanced.any?
    end
    markup do |m|
      m.h1 "#{level.titleize} Courses"
      course_list_markup(m, courses)
    end
  end
  
  def course_list_markup(m, courses)
    courses.each do |course|
      m.div class: 'col-xs-12 col-md-4' do
        m.div class: 'panel' do
          unless current_user.courses.include?(course)
          m.div class: 'panel-body course-panel' do
            m.h3 do
              m.a course.title, class: 'course-enroll-link', href: course_path(course)
            end
            m.hr
            m.p course.summary
            m.hr
            m.div class: 'col-md-6 col-md-offset-3 col-xs-6 col-xs-offset-3' do
              m.button class: 'btn btn-success', method: :post do
                unless current_user.courses.include?(course)
                  m.a "Enroll", href: user_enrollment_path(course)
                else
                  m.a "Go to Course", href: course_path(course)
                end
              end
            end
          end
        else
          m.div class: 'panel-body course-panel-enrolled' do
            m.h3 do
              m.a course.title, class: 'course-enroll-link', href: course_path(course)
            end
            m.hr
            m.p course.summary
            m.hr
            m.div class: 'col-md-6 col-md-offset-3 col-xs-6 col-xs-offset-3' do
              m.button class: 'btn btn-success', method: :post do
                unless current_user.courses.include?(course)
                  m.a "Enroll", href: user_enrollment_path(course)
                else
                  m.a "Go to Course", href: course_path(course)
                end
              end
            end
          end
          end
        end
      end
    end
  end
end


