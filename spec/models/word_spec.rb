require 'rails_helper'

RSpec.describe Word, type: :model do
  context "when calling attributes" do
    let(:word) { build :word }
    let(:translation) { build :translation, word: word }
    
    it "returns the word attribute" do
      expect(word.word).to eq("分かる")
    end
    
    it "returns the hiragana attribute" do
      expect(word.hiragana).to eq("わかる")
    end
    
    it "returns the reading attribute" do
      expect(word.reading).to eq("wakaru")
    end
    
    it "returns the part_of_speech attribute" do
      expect(word.part_of_speech).to eq("v5r")
    end
    
    
    it "returns the transations attribute" do
      expect(translation.word.reading).to eq("wakaru")
    end
  end
  
  context "Hiragana converter" do
    it "Romanizes the hiragana before validation" do
      @word = Word.new(word: "鉄", hiragana: "てつ", part_of_speech: "noun")
      @word.valid?
      expect(@word.reading).to eq("tetsu")
    end
    
    it "Romanizes combination characters before validation" do
      @word = Word.new(word: "今日", hiragana: "きょう", part_of_speech: "noun")
      @word.valid?
      expect(@word.reading).to eq("kyou")
    end
    
    it "Romanizes hiragana with double consonants before validation" do
      @word = Word.new(word: "作家", hiragana: "さっか", part_of_speech: "Noun")
      @word.valid?
      expect(@word.reading).to eq("sakka")
    end
    
    it "Romanizes hiragana with double consonants followed by combination characters" do
      @word = Word.new(word: "脱去", hiragana: "だっきょ", part_of_speech: "Noun")
      @word.valid?
      expect(@word.reading).to eq("dakkyo")
    end
    
    it "Sets the reading (romaji) attribute properly from the hiragana without changing the hiragana" do
      @w = Word.new(word: "書く", hiragana: "かく", part_of_speech: "verb")
      @w.valid?
      expect(@w.hiragana).to eq("かく")
    end
  end
  
  describe Japanese::VerbIdentifier do
    context "When handling verbs that end in ru" do
      it "Sets the appropriate verb class for suru" do
        @suru = Word.new(word: "する", hiragana: "する", part_of_speech: "verb")
        @suru.resolve_verb_class
        expect(@suru.part_of_speech).to eq("v-suru")
      end
    
      it "Sets the appropriate verb class for kuru" do
        @kuru = Word.new(word: "来る", hiragana: "くる", part_of_speech: "verb")
        @kuru.resolve_verb_class
        expect(@kuru.part_of_speech).to eq("v-kuru")
      end
    
      it "Sets the appropriate verb class for aru" do
        @aru = Word.new(word: "ある", hiragana: "ある", part_of_speech: "verb")
        @aru.resolve_verb_class
        expect(@aru.part_of_speech).to eq("v-aru")
      end
    
      it "Sets the appropriate verb class for aru in kanji" do
        @aru_kanji = Word.new(word: "有る", hiragana: "ある", part_of_speech: "verb")
        @aru_kanji.resolve_verb_class
        expect(@aru_kanji.part_of_speech).to eq("v-aru")
      end
    
      it "Sets the appropriate verb class for irassharu" do
        @irassharu = Word.new(word: "いらっしゃる", hiragana: "いらっしゃる", part_of_speech: "verb")
        @irassharu.resolve_verb_class
        expect(@irassharu.part_of_speech).to eq("v5r-i")
      end
    
      it "Sets the appropriate verb class for irassharu with kanji" do
        @irassharu = Word.new(word: "居らっしゃる", part_of_speech: "verb")
        @irassharu.resolve_verb_class
        expect(@irassharu.part_of_speech).to eq("v5r-i")
      end
    
      it "Sets the appropriate verb class for -iru consonant verbs" do
        @chigiru = Word.new(word: "契る", hiragana: "ちぎる", part_of_speech: "verb")
        @chigiru.resolve_verb_class
        expect(@chigiru.part_of_speech).to eq("v5r")
      end
    
      it "Sets the appropriate verb class for -eru consonant verbs" do
        @keru = Word.new(word: "蹴る", hiragana: "ける", part_of_speech: "verb")
        @keru.resolve_verb_class
        expect(@keru.part_of_speech).to eq("v5r")
      end
    
      it "Sets the appropriate verb class for -ru verbs not ending in -eru or -iru" do
        @moguru = Word.new(word: "潜る", hiragana: "もぐる", part_of_speech: "verb")
        @moguru.resolve_verb_class
        expect(@moguru.part_of_speech).to eq("v5r")
      end
    
      it "Sets the appropriate verb class for -iru vowel verbs" do
        @miru = Word.new(word: "見る", hiragana: "みる", part_of_speech: "verb")
        @miru.resolve_verb_class
        expect(@miru.part_of_speech).to eq("v1")
      end
    
      it "Sets the appropriate verb class for -eru vowel verbs" do
        @taberu = Word.new(word: "食べる", hiragana: "たべる", part_of_speech: "verb")
        @taberu.resolve_verb_class
        expect(@taberu.part_of_speech).to eq("v1")
      end
    
      it "Does not resolve ambiguous -ru verbs" do
        @heru = Word.new(word: "へる", hiragana: "へる", part_of_speech: "verb")
        @heru.resolve_verb_class
        expect(@heru.part_of_speech).to eq("verb")
      end
    end
    
    context "When handling other verbs" do
      it "Sets the appropriate verb class for -bu verbs" do
        @yobu = Word.new(word: "呼ぶ", part_of_speech: "verb")
        @yobu.resolve_verb_class
        expect(@yobu.part_of_speech).to eq("v5b")
      end
      
      it "Sets the appropriate verb class for -gu verbs" do
        @oyogu = Word.new(word: "泳ぐ", part_of_speech: "verb")
        @oyogu.resolve_verb_class
        expect(@oyogu.part_of_speech).to eq("v5g")
      end
      
      it "Sets the appropriate verb class for -ku verbs" do
        @fuku = Word.new(word: "拭く", part_of_speech: "verb")
        @fuku.resolve_verb_class
        expect(@fuku.part_of_speech).to eq("v5k")
      end
      
      it "Sets the appropriate verb class for -mu verbs" do
        @yomu = Word.new(word: "読む", part_of_speech: "verb")
        @yomu.resolve_verb_class
        expect(@yomu.part_of_speech).to eq("v5m")
      end
      
      it "Sets the appropriate verb class for -nu verbs" do
        @shinu = Word.new(word: "死ぬ", part_of_speech: "verb")
        @shinu.resolve_verb_class
        expect(@shinu.part_of_speech).to eq("v5n")
      end
      
      it "Sets the appropriate verb class for -su verbs" do
        @hanasu = Word.new(word: "話す", part_of_speech: "verb")
        @hanasu.resolve_verb_class
        expect(@hanasu.part_of_speech).to eq("v5s")
      end
      
      it "Sets the appropriate verb class for -tsu verbs" do
        @hanatsu = Word.new(word: "放つ", part_of_speech: "verb")
        @hanatsu.resolve_verb_class
        expect(@hanatsu.part_of_speech).to eq("v5t")
      end
      
      it "Sets the appropriate verb class for -u verbs" do
        @kau = Word.new(word: "飼う", part_of_speech: "verb")
        @kau.resolve_verb_class
        expect(@kau.part_of_speech).to eq("v5u")
      end
    end
    
    context "When handling non -ru irregular verb classes" do
      it "Sets the appropriate verb class for 行く" do
        @iku = Word.new(word: "行く", part_of_speech: "verb")
        @iku.resolve_verb_class
        expect(@iku.part_of_speech).to eq("v5k-s")
      end
      
      it "Sets the appropriate verb class for 問う" do
        @tou = Word.new(word: "問う", part_of_speech: "verb")
        @tou.resolve_verb_class
        expect(@tou.part_of_speech).to eq("v5u-s")
      end
    end
  end
  
  describe Japanese::Conjugator do
    context "when conjugating causative passive forms" do
      it "conjugates 'v5k' verbs properly" do
        @kaku = Word.new(
                          word: "書く", 
                          hiragana: "かく", 
                          part_of_speech: "verb",
                          has_causative: true,
                          has_passive: true,
                          has_causative_passive: true
                          )
        @kaku.valid?
        @kaku.process_verb
        expect(@kaku.causative_passive_dictionary_form).to eq("書かされる")
        expect(@kaku.hiragana_forms[:causative_passive_dictionary_form]).to eq("かかされる")
        expect(@kaku.romaji_forms[:causative_passive_dictionary_form]).to eq("kakasareru")
      end
      
      it "conjugates v5b verbs properly" do
        @yobu = Word.new(
                          word: "呼ぶ",
                          hiragana: "よぶ",
                          part_of_speech: "verb",
                          has_causative: true,
                          has_causative_passive: true,
                          has_passive: true
                          )
        @yobu.valid?
        @yobu.process_verb
        expect(@yobu.causative_passive_dictionary_form).to eq("呼ばされる")
      end
      
      it "conjugates v5g verbs properly" do
        @oyogu = Word.new(
                          word: "泳ぐ",
                          hiragana: "およぐ",
                          part_of_speech: "verb",
                          has_causative: true,
                          has_causative_passive: true,
                          has_passive: true
                          )
        @oyogu.valid?
        @oyogu.process_verb
        expect(@oyogu.causative_passive_dictionary_form).to eq("泳がされる")
      end
      
      it "conjugates v5m verbs properly" do
        @yomu = Word.new(
                         word: "読む",
                         hiragana: "よむ",
                         part_of_speech: "verb",
                         has_causative: true,
                         has_causative_passive: true,
                         has_passive: true
                         )
        @yomu.valid?
        @yomu.process_verb
        expect(@yomu.causative_passive_dictionary_form).to eq("読まされる")
      end
      
      it "conjugates v5n verbs properly" do
        @shinu = Word.new(
                          word: "死ぬ",
                          hiragana: "しぬ",
                          part_of_speech: "verb",
                          has_causative: true,
                          has_causative_passive: true,
                          has_passive: true
                          )
        @shinu.valid?
        @shinu.process_verb
        expect(@shinu.causative_passive_dictionary_form).to eq("死なされる")
      end
      
      it "conjugates v5r verbs properly" do
        @shiru = Word.new(
                          word: "知る",
                          hiragana: "しる",
                          part_of_speech: "verb",
                          has_causative: true,
                          has_causative_passive: true,
                          has_passive: true
                          )
        @shiru.valid?
        @shiru.process_verb
        expect(@shiru.causative_passive_dictionary_form).to eq("知らされる")
      end
      
      it "conjugates v5s verbs properly" do
        @hanasu = Word.new(
                           word: "話す",
                           hiragana: "はなす",
                           part_of_speech: "verb",
                           has_causative: true,
                           has_causative_passive: true,
                           has_passive: true
                           )
        @hanasu.valid?
        @hanasu.process_verb
        expect(@hanasu.causative_passive_dictionary_form).to eq("話される")
      end
      
      it "conjugates v5t verbs properly" do
        @utsu = Word.new(
                         word: "打つ",
                         hiragana: "うつ",
                         part_of_speech: "verb",
                         has_causative: true,
                         has_causative_passive: true,
                         has_passive: true
                         )
        @utsu.valid?
        @utsu.process_verb
        expect(@utsu.causative_passive_dictionary_form).to eq("打たされる")
      end
      
      it "conjugates v5u verbs properly" do
        @kau = Word.new(
                        word: "買う",
                        hiragana: "かう",
                        part_of_speech: "verb",
                        has_causative: true,
                        has_causative_passive: true,
                        has_passive: true
                        )
        @kau.valid?
        @kau.process_verb
        expect(@kau.causative_passive_dictionary_form).to eq("買わされる")
      end
      
      it "conjugates v5k-s verbs properly" do
        @iku = Word.new(
                        word: "行く",
                        hiragana: "いく",
                        part_of_speech: "verb",
                        has_causative: true,
                        has_causative_passive: true,
                        has_passive: true
                        )
        @iku.valid?
        @iku.process_verb
        expect(@iku.causative_passive_dictionary_form).to eq("行かされる")
      end
      
      it "conjugates v5u-s verbs properly" do
        @tou = Word.new(
                        word: "問う",
                        hiragana: "とう",
                        part_of_speech: "verb",
                        has_causative: true,
                        has_causative_passive: true,
                        has_passive: true
                        )
        @tou.valid?
        @tou.process_verb
        expect(@tou.causative_passive_dictionary_form).to eq("問わされる")
      end
      
      it "conjugates vowel verbs properly" do
        @taberu = Word.new(
                           word: "食べる",
                           hiragana: "たべる",
                           part_of_speech: "verb",
                           has_causative: true,
                           has_causative_passive: true,
                           has_passive: true
                           )
        @taberu.valid?
        @taberu.process_verb
        expect(@taberu.causative_passive_dictionary_form).to eq("食べさせられる")
      end
      
      it "conjugates suru properly" do
        @suru = Word.new(
                         word: "する",
                         hiragana: "する",
                         part_of_speech: "verb",
                         has_causative: true,
                         has_causative_passive: true,
                         has_passive: true
                         )
        @suru.valid?
        @suru.process_verb
        expect(@suru.causative_passive_dictionary_form).to eq("させられる")
      end
    end
  end
  
  context "when running callbacks" do
    it "sets all has_...? attributes to true before validation if not set to false initially" do
      @word = Word.new(word: "する", hiragana: "する", part_of_speech: "verb")
      @word.valid?
      expect(@word.has_causative).to be true
      expect(@word.has_causative_passive).to be true
      expect(@word.has_passive).to be true
      expect(@word.has_imperative).to be true
      expect(@word.has_volitional).to be true
    end
    
    it "leaves has_... attributes set to false if initially set in the call to create or new" do
      @word = Word.new(word: "上がる", hiragana: "あがる", part_of_speech: "verb", has_passive: false)
      @word.valid?
      expect(@word.has_passive).to be false
      expect(@word.has_causative).to be true
      expect(@word.has_causative_passive).to be true
    end
  end
end
