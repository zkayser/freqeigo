class EditDeckPresenter < ModelPresenter
  delegate :params, :link_to, :card_path, :check_box_tag, to: :view_context
  
  def table_header
    markup do |m|
      m.th ""
      m.th "Top"
      m.th "Bottom"
    end
  end
  
  def table_row_for_deck_edit(card)
    markup do |m|
      m.tr do
        m.td class: "checkbox-cell" do
         m.content check_box_tag("card_ids[]", card.id)
        end
        m.td card.top
        m.td card.bottom
      end
    end
  end
  
end