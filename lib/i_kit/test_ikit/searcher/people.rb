class IKit::TestIkit::Searcher::People

  class << self
    def get_query(query)
      @get_query =  { filtered: {
                        query: {}
                      }
                  }
      query = query.to_s.strip
      query = query.gsub(/\s+/, " ")
      query = query.gsub(/-/, " ")
      if query.length.zero?
        @get_query[:filtered][:query][:match_all] = {}
      else
        @get_query[:filtered][:query][:multi_match] = {
                                            query:  query,
                                            operator: 'AND',
                                            fields: ["_all"]
                                          }
      end
      @get_query
    end

    def get_sort(sort)
      return {} if sort.blank?
      field     = sort.keys.first
      direction = sort.values.first
      { field => { order: direction, missing: :_last }}
    end

    def get_paging(paging)
      return { from: 0, size: 10 } if paging.blank?
      paging.slice(:from, :size)
    end

  end

  def initialize(query, options={})
    @search_settings =  {   
                           query:  IKit::TestIkit::Searcher::People.get_query(query),
                           sort:   IKit::TestIkit::Searcher::People.get_sort(options[:sort]),
                           highlight: {
                                   pre_tags: ['<em class="label label-highlight">'],
                                   post_tags: ['</em>'],

                                   fields: { "*" => { number_of_fragments: 0 } },
                            }
                        }
                        
    @search_settings.merge! IKit::TestIkit::Searcher::People.get_paging(options[:paging])
  end

  def get_records
    # search_settings = {default_operator: 'AND', size: klass.count}
    # search_settings.merge! sort: { by sort_column, @sort_direction}} if was_given_sort_column?
    records = Person.search(@search_settings, preference: '_primary').records
    records
  end
end
