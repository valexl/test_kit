class IKit::TestIkit::Parser::Row
  def initialize(row)
    @row     = row
    @headers = [:name, :city, :country, :credential, :earned, :status]
  end

  def get_attributes
    res = {}
    @row.search("td span").each_with_index do |span, index|
      header = @headers[index]
      res[header] = header == :earned ? span.text.to_date : span.text.to_s
    end
    res
  end
end
