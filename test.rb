# encoding: utf-8
require 'csv'
require 'stuff-classifier'

states = {  
  :al => "AL Alabama",
  :ak => "AK Alaska",
  :as => "AS American Samoa",
  :az => "AZ Arizona",
  :ar => "AR Arkansas",
  :ca => "CA California",
  :co => "CO Colorado",
  :ct => "CT Connecticut",
  :de => "DE Delaware",
  :dc => "DC District of Columbia",
  :fm => "FM Fed. States of Micronesia",
  :fl => "FL Florida",
  :ga => "GA Georgia",
  :gu => "GU Guam",
  :hi => "HI Hawaii",
  :id => "ID Idaho",
  :il => "IL Illinois",
  :in => "IN Indiana",
  :ia => "IA Iowa",
  :ks => "KS Kansas",
  :ky => "KY Kentucky",
  :la => "LA Louisiana",
  :me => "ME Maine",
  :mh => "MH Marshall Islands",
  :md => "MD Maryland",
  :ma => "MA Massachusetts",
  :mi => "MI Michigan",
  :mn => "MN Minnesota",
  :ms => "MS Mississippi",
  :mo => "MO Missouri",
  :mt => "MT Montana",
  :ne => "NE Nebraska",
  :nv => "NV Nevada",
  :nh => "NH New Hampshire",
  :nj => "NJ New Jersey",
  :nm => "NM New Mexico",
  :ny => "NY New York",
  :nc => "NC North Carolina",
  :nd => "ND North Dakota",
  :mp => "MP Northern Mariana Is.",
  :oh => "OH Ohio",
  :ok => "OK Oklahoma",
  :or => "OR Oregon",
  :pw => "PW Palau",
  :pa => "PA Pennsylvania",
  :pr => "PR Puerto Rico",
  :ri => "RI Rhode Island",
  :sc => "SC South Carolina",
  :sd => "SD South Dakota",
  :tn => "TN Tennessee",
  :tx => "TX Texas",
  :ut => "UT Utah",
  :vt => "VT Vermont",
  :va => "VA Virginia",
  :vi => "VI Virgin Islands",
  :wa => "WA Washington",
  :wv => "WV West Virginia",
  :wi => "WI Wisconsin",
  :wy => "WY Wyoming"
}

timezones = [
  "Hawaii",
  "Alaska",
  "Pacific Time (US & Canada)",
  "Arizona",
  "Mountain Time (US & Canada)",
  "Central Time (US & Canada)",
  "Eastern Time (US & Canada)",
  "Indiana (East)"
]

test = [
  "Iowa",
  "Paw paw Michigan",
  "World Wide",
  "SC",
  "Nashville",
  "Houston, Texas",
  "DC, MD, VA (DMV) WORLDWIDE",
  "Omaha",
  "SoCal, USA",
  "Tampa,  Florida",
  "Malibu Beach",
  "Riverbanks Zoo",
  "Mostly Boise",
  "Music City, USA (Middle TN)",
  "USA",
  "Collingswood",
  "Florida",
  "North Carolina",
  "Washington, DC",
  "Western PA"
]


cls = StuffClassifier::Bayes.new("Which State")


puts "Loading base data"
states.each do |key, value|
  cls.train(key, value)
  s = value.split
  cls.train(key, s[0])
  cls.train(key, s[1])
end

@a = 0
puts "Enriching with 200,000 cities"

# CSV.foreach("us_cities_clean.csv") do |row|
#   begin
#       cls.train(row[1], "#{row[0]} #{row[1]}")
#     rescue
#       puts "opps"
#     end
#   @a +=1
# end

puts @a

puts "Running test set"
test.each do |location|
   state = cls.classify(location)
   puts "#{state} - #{location}"
end