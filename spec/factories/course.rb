FactoryGirl.define do
  factory :course, :class => 'Course' do
    title 'Basic Course'
    summary 'Learning basics'
    level 'Beginner'
    appx_length '1 week'
  end
end