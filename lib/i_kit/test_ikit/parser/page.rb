class IKit::TestIkit::Parser::Page
  def initialize(page)
    @page     = page
  end

  def get_attributes
    attributes = @page.search("tr[id]").map do |tr|
                  IKit::TestIkit::Parser::Row.new(tr).get_attributes      
                end
    fix_blank_attributes(attributes)
  end

  private
    def fix_blank_attributes(attributes)
      previous_record = attributes.shift
      result          = [previous_record]
      attributes.each do |attrs|
        attrs[:name]    = previous_record[:name]    if attrs[:name].blank?
        attrs[:city]    = previous_record[:city]    if attrs[:city].blank?
        attrs[:country] = previous_record[:country] if attrs[:country].blank?
        previous_record = attrs
        result.push(attrs)
      end
      result
    end

end
