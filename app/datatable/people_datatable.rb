class PeopleDatatable
  class TableItem
    delegate :link_to, :display_actions_for, to: :@view

    attr_reader :item
    def initialize(view, elasticsearch_result_item)
      @item     = elasticsearch_result_item
      @view     = view
      @item_resource = item.type
    end
      
    def humanize_date(column_date_name)
      item.send(column_date_name).try(:to_date).to_s
    end
      
    def humanize_column(column_name)
      return item.send(column_name) if item.try(:highlight).blank?
      return item.send(column_name) if item.try(:highlight)[column_name].blank?
      item.highlight[column_name].join.html_safe
    end

    def link_with_title(column_name)
      path_to_item = @view.send("#{@item_resource}_path", item.id)
      link_to(humanize_column(column_name), path_to_item)
    end

    def link_to_nested_resource(resource_name)
      begin
        path_to_resource = @view.send("#{resource_name}_path", item.send(resource_name).id)
        link_to(get_title_for_nested_resource(resource_name), path_to_resource)
      rescue NoMethodError
        '-'
      end
    end

    def actions
      display_actions_for(item, @item_resource.camelize.constantize)
    end
      
    private
      def get_title_for_nested_resource(resource_name)
        column_name = "#{resource_name}.to_s"
        return item.send(resource_name)[:to_s] if item.try(:highlight).blank?
        return item.send(resource_name)[:to_s] if item.try(:highlight)[column_name].blank?
        item.highlight[column_name].join.html_safe
      end

  end

  ############################
  ############################

  delegate :params, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: klass.count,
      iTotalDisplayRecords: total_count,
      aaData: get_data
    }
  end

private
  def was_select_sorting_column?
    params[:iSortingCols].to_i > 0
  end
  
  def has_search_query?
    params[:sSearch].present?
  end

  def klass
    self.class.to_s.gsub("Datatable", '').singularize.constantize
  end

  def get_resource_name
    klass.to_s.underscore
  end

  def get_data
    begin
      data
    rescue Elasticsearch::Transport::Transport::Errors::BadRequest
      Rails.logger.error("BadRequest of Elasticsearch when try call method data")
      []
    end
  end

  def data
    index = (page - 1) * per_page 
    records.map do |person|
      record = PeopleDatatable::TableItem.new @view, person

      index += 1

      [
        index,
        record.humanize_column(:name),
        record.humanize_column(:city),
        record.humanize_column(:region),
        record.humanize_column(:country),
        record.humanize_column(:credential),
        record.humanize_column(:earned),
        record.humanize_column(:status),
      ]
    end
  end

  def available_columns
    [nil, :"name.sort", :"city.sort", :"region.sort", :"country.sort", :credential, :earned, :status]
  end

  def total_count
    begin
      fetch_records.total 
    rescue Elasticsearch::Transport::Transport::Errors::BadRequest
      Rails.logger.error("BadRequest of Elasticsearch when try call method total")
      0
    end
  end

  def records
    @records ||= fetch_records
  end

  def fetch_records
    return @fetch_records if @fetch_records
    options  = {} 
    options[:sort]   = { sort_column => sort_direction }
    options[:paging] = { from: from_record, size: per_page }
    searcher = IKit::TestIkit::Searcher::People.new params[:sSearch], options
    @fetch_records = searcher.get_records
    @fetch_records = @fetch_records.results
    @fetch_records
  end

  def sort_column
    return available_columns[params[:iSortCol_0].to_i] if was_select_sorting_column?
    return "_score" if has_search_query?
    "updated_at"
  end

  def sort_direction
    return "desc" unless was_select_sorting_column?
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

  def from_record
    (page - 1) * per_page
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end
end

