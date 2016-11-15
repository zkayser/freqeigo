module CardsHelper
  
  def current_card_percentage(card, precision = 0)
    unless card.overall_seen == 0
      number_to_percentage((card.overall_correct.to_f / card.overall_seen.to_f) * 100, precision: precision)
    else
      0
    end
  end
  
end