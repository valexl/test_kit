FactoryGirl.define do
  factory :person do
    name       { generate   :random_name }
    region     { generate   :random_region }
    city       { generate   :random_city }
    country    { generate   :random_country }
    credential "PMP"
    earned     { generate   :random_earned }
    status     "Active"
  end

end
