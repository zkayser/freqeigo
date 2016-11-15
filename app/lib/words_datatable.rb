module DataTable
  class WordsDataTable
    delegate :params, :h, :link_to, to: :@view
  
    def initialize(view)
      @view = view
    end
  
    def as_json(options = {})
      {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: Word.all.to_a.length,
        iTotalDisplayRecords: words.total_count,
        aaData: data
      }
    end

    private
  
    def data
      words.map do |word|
        ts = ""
        t_array = []
        word.translations.each do |t|
          t_array << t
        end
        ts = t_array.join('; ')
        [
          link_to(word.word, word),
          h(ts),
          h(word.hiragana),
          h(word.reading)
        ]
      end
    end
  
    def words
      @words || fetch_words
    end
  
    def fetch_words
      words = Word.order_by("#{sort_column} #{sort_direction}")
      words = Words.page(page).per(per_page)
      if params[:sSearch].present?
        search = Word.solr_search do
          fulltext params[:sSearch]
        end
        words = search.results.to_a
      end
      words
    end
  
    def page
      params[:iDisplayStart].to_i/per_page + 1
    end
  
    def per_page
      params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
    end
  
    def sort_column
      columns = %w[word translations hiragana romaji]
      columns[params[:iSortCol_0].to_i]
    end
  
    def sort_direction
      params[:sSortDir_0] == "desc" ? "desc" : "asc"
    end
  end
end