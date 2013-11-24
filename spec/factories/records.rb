# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :record do
    year 2000
    value 20.5
    gender "female"
    measurement "percent"
    country
    dataset
  end
end
