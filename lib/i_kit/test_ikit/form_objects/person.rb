class IKit::TestIkit::FormObjects::Person

  def initialize(attrs)
    @attrs = attrs
  end

  def save!
    person = Person.find_or_initialize_by name: @attrs[:name]
    person.update_attributes! @attrs.merge(city: get_city, region: get_region) 
  end

  def get_city 
    @attrs[:city].split(",").first
  end

  def get_region
    @attrs[:city].split(",").second
  end
end
