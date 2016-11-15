require 'rails_helper'

RSpec.describe ExampleSentence, type: :model do
  
  before(:each) do
    Mongoid.purge!
  end
  
  describe Japanese::Parser do
    context "when setting constituent arrays" do
      before(:each) do
        @sentence = ExampleSentence.new(sentence: "無理に食べさせられていたから調子が悪くなっちゃった。")
        @sentence.set_constituents
      end
      
      it "sets the surface_constituents array on the sentence" do
        expect(@sentence.surface_constituents).to eq(["無理", "に", "食べ", "させ", "られ", "て", "い", "た", "から", "調子", "が", "悪く", "なっ", "ちゃっ", "た", "。"])
      end
      
      it "sets the pos_constituents array on the sentence" do
        expect(@sentence.pos_constituents).to eq(["名詞", "助詞", "動詞", "助動詞", "助動詞", "助詞", "助動詞", "助動詞", "助詞", "名詞", "助詞", "形容詞", "助動詞", "助動詞", "助動詞", "特殊"])
      end
    
      it "sets the reading_constituents array on the sentence" do
        expect(@sentence.reading_constituents).to eq(%w(むり に たべ させ られ て い た から ちょうし が わるく なっ ちゃっ た 。))
      end
      
      it "transforms the reading_constituents to set the romaji_constituents array" do
        expect(@sentence.romaji_constituents).to eq(%w(muri ni tabe sase rare te i ta kara choushi ga waruku na cha ta .))
      end
    end
    
    context "when creating a new example sentence" do
      before(:each) do
        @sentence = ExampleSentence.new(sentence: "無理に食べさせられていたから調子が悪くなっちゃった。")
        @sentence.valid?
      end
      
      it "initializes the sentence in words properly" do
        expect(@sentence.as_words).to eq("muri ni tabe sase rare te i ta kara choushi ga waruku na cha ta")
      end
    end
  end
end
