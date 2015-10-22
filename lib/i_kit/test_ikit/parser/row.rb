class IKit::TestIkit::Parser::Row
  def initialize(row)
    @row     = row
    @headers = [:name, :city, :country, :credential, :daet, :status]
  end

  def get_attributes
    res = {}
    @row.search("td span").each_with_index do |span, index|
      res[@headers[index]] = span.text.to_s
    end
    res
  end
end
