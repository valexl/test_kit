class IKit::TestIkit::Parser::Page
  def initialize(page)
    @page     = page
  end

  def get_attributes
    @page.search("tr[id]").map do |tr|
      IKit::TestIkit::Parser::Row.new(tr).get_attributes      
    end
  end

end
