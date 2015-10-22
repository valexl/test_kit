# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence(:random_name)    { Forgery('name').full_name }
  sequence(:random_region)  { Forgery('address').state}
  sequence(:random_city)    { Forgery('address').city}
  sequence(:random_country) { Forgery('address').country}
  sequence(:random_earned)  { Forgery('date').date.to_s }
end
