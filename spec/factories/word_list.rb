FactoryGirl.define do
  factory :word_list, :class => 'WordList' do
    title "Word List"
    words create(:word)
  end
end