module ApplicationHelper
  # Provides the appropriate checkboxes for the custom deckify form
  def matches_for_attribute(matches, attribute)
    str = ''
    str << '<hr/>'
    matches.each do |match|
      unless match.downcase == attribute.downcase
        str << '<label>' + check_box_tag("#{attribute}" + "[#{match.downcase}]", "1", false, class: "checkbox") + " #{outward_match(match)} " + "</label>"
      end
    end
    str << "<hr/>"
    return str.html_safe
  end
  
  # Display attributes for users, which may be different from attributes as
  # represented on the system ("kanji" for users, but "word" on the system)
  def outward_match(match)
    if match == "word"
      return "kanji"
    elsif match == "reading"
      return "romaji"
    else
      return match
    end
  end
  
  # Provides the full html output for the custom deck form
  def html_output_for_custom_deckify(matches)
    str = ''
    matches.each do |match|
      unless match == "synonyms" || match == "antonyms"
        str << '<h2>' + "Match flashcards with #{outward_match(match).upcase} on the front to: " + '</h2>'
        str << matches_for_attribute(matches, match)
      end
    end
    return str.html_safe
  end
      
end
