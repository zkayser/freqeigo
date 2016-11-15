module CalendarsHelper
  
  def calendar_string
    @month = params[:month] || Date.current.strftime('%B')
    @year = params[:year] || Date.current.year
    @day = 1
    @date = Date.parse("#{@day} #{@month} #{@year}")
    @prev_month = @date.prev_month.strftime('%B')
    @next_month = @date.next_month.strftime('%B')
    @today = Date.current.day
    @end_date = @date.end_of_month.day
    @beginning_day = @date.beginning_of_month.strftime('%A')
    @end_day = @date.end_of_month.strftime('%A')
    
    html = "<div class=\"month\"><ul><li class=\"prev\">#{"<a href=\"/users/#{current_user.id}/calendar/#{@prev_month}\">&#10094</a>".html_safe}</li>
            <li class=\"next\">#{"<a href=\"/users/#{current_user.id}/calendar/#{@next_month}\">&#10095</a>".html_safe}</li>"
    html += "<li class=\"month-title\">#{@month}<br/>"
    html += "<span style=\"font-size: 18px\">#{@year}</span>"
    html += "</li></ul></div>"
    html += "<ul class=\"weekdays\">"
    days = %w(sunday monday tuesday wednesday thursday friday saturday)
    days.each do |day|
      html += "<li>#{day.upcase}</li>"
    end
    html += "</ul>".html_safe
    html += "<ul class=\"days\">"
    beginning_offset = @date.beginning_of_month.wday
    beginning_offset.times do 
      html += "<li></li>"
    end
    @end_date.times do |date|
      if date + 1 == @today && @date.strftime('%B') == Date.current.strftime('%B') && @date.year == Date.current.year
        html += "<li><span class=\"active\">#{@today}</span></li>"
      else
        html += "<li>#{date + 1}</li>"
      end
    end
    html += "</ul>".html_safe
  end
end
