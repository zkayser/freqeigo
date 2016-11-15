module CardAttributes
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
    def set_default_card_pairings(*attributes)
      define_method("defaults") do
        tops = []
        bottoms = []
        attributes.each do |attribute|
          tops << attribute[0]
          bottoms << attribute[1]
        end
      end
    end
  end
end