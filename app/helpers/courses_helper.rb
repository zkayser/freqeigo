module CoursesHelper
  
  def previous_page
    if @page > 1
      html = link_to "Previous", study_word_list_path(@word_list.course.id, (@page - 1))
      html.html_safe
    end
  end
  
  def next_page
    unless @page > (@word_list.words.length / 10)
      html = link_to "Next", study_word_list_path(@word_list.course.id, (@page + 1))
      html.html_safe
    end
  end
    
 
end
