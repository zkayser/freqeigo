module Japanese
  module Parser
    
  # This module hooks up with the Yahoo! Japanese morphological parser API. 
  # Yahoo ID set in development as of now under ENV["YAHOOID"]
  
  ID = ENV["YAHOOID"]
  
  def get_xml_results
    string = build_query_string(self.sentence)
    uri = parse_query_uri(string)
    results = execute_query(uri)
    unescape_xml(results)
  end
  
  def extract_xml_doc
    Nokogiri::XML.parse(self.get_xml_results)
  end
  
  
  def set_constituents
    search_paths(surface: true, reading: true, pos: true, baseform: true, romaji: true)
  end
  
  # Gets an array of parameters to pass to the doc.xpath of the xml document
  def search_paths(options = {})
    paths = []
    # Check if options include 'surface, reading, pos, baseform, or romaji'
    if options[:surface]
      self.surface_constituents = []
      paths << 'surface'
    end
    if options[:reading]
      self.reading_constituents = []
      paths << 'reading'
    end
    if options[:pos]
      self.pos_constituents = []
      paths << 'pos'
    end
    if options[:baseform]
      self.baseform_constituents = []
      paths << 'baseform'
    end
    doc = self.extract_xml_doc
    paths.each do |path| # Run the query for each search path specified in options
      doc.xpath("//xmlns:#{path}").each do |constituent|
        eval "self.#{path}_constituents << constituent.text"
      end
    end
    if options[:romaji]
      self.romaji_constituents = self.set_romaji_constituents
    end
  end
  
  def set_romaji_constituents
    romaji = []
    self.reading_constituents.each do |hiragana|
      dup = hiragana.dup
      romaji << Japanese::HiraganaConverter.convert_hiragana(dup)
    end
    self.romaji_constituents = romaji
  end
    
  
  # Finds existing word instances in the sentence using baseforms
  def find_embedded_words(baseforms)
    search_hits = []
    baseforms.each do |base|
      search = Word.solr_search do
        fulltext base
      end
      if search.results.any?
        search_hits << search.results
      end
    end
    return search_hits
  end
  
    # Build the query string
    def build_query_string(query)
      unescaped_uri = "http://jlp.yahooapis.jp/MAService/V1/parse?appid=#{ID}&results=ma&response=surface,reading,pos,baseform&sentence=#{query}"
      # Escape the query
      URI.escape(unescaped_uri)
    end
    
    # Parse the url and query string
    def parse_query_uri(query_string_request)
      URI.parse(query_string_request)
    end
    
    # Get the results
    def execute_query(uri)
      Net::HTTP.get(uri)
    end
    
    # Unescape the results
    def unescape_xml(results)
      CGI.unescape(results)
    end
  end
end