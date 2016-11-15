class DeckDecorator < Draper::Decorator
  delegate_all
  
  def draw_label
    h.label_tag("This is a label yo!")
  end
  
  def draw_check_box(card)
    h.check_box_tag("card_ids[]", card.id)
  end

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

end
