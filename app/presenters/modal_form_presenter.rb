class ModalFormPresenter < ModelPresenter
  delegate :render, :raw, to: :view_context
  
  def modal_popover_button(text)
    markup do |m|
      m.button text, class: 'btn btn-primary', "data-toggle" => "modal", "data-target" => "#exampleModal", "data-whatever" => "@mdo"
    end
  end
  
  def render_view_partial(partial)
    markup do |m|
      m.div do
      end
    end
  end
  
  def modal_fade(form_title, form)
    markup do |m|
      m.div class: "modal fade", id: "exampleModal", tabindex: "-1", role: "dialog", "aria-labelledby" => "exampleModalLabel" do
        m.div class: "modal-dialog", role: "document" do
          m.div class: "modal-content" do
            m.div class: "modal-header" do
              m.button type: "button", class: "close", "data-dismiss" => "modal", "aria-label" => "Close" do
                m.span "x", "aria-hidden" => "true"
              end
              m.h4 form_title, class: "modal-title", id: "exampleModalLabel"
            end
            m.div view_context.raw(form), class: "modal-body" 
            m.div class: "modal-footer"
          end
        end
      end
    end
  end

end


=begin
<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#exampleModal" data-whatever="@mdo">Create Custom Deck</button>
        <div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel">
          <div class="modal-dialog" role="document">
            <div class="modal-content">
              <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="exampleModalLabel">Customize your own flashcard deck</h4>
              </div>
              <div class="modal-body">
                <%= render 'custom_deck_form' %>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary">Send message</button>
              </div>
            </div>
          </div>
        </div>
=end