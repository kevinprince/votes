require 'bunny'
require 'active_support/json'
require 'mongo'
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

cls = StuffClassifier::Bayes.new("Which State")

states.each do |key, value|
  cls.train(key, value)
end

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

b.start
  q = b.queue('state_enriching')

  q.subscribe() do |msg|
    data = j.decode(msg[:payload])

    unless (data['time_zone'].nil? || data['user_location'].nil?)
      if timezones.include? data['time_zone']
        state = cls.classify(data['user_location'])
      else
        state = 'XX'
      end
    else
      state = 'XX'
    end

    tweets.update({"_id" => data["_id"]}, {"$set" => {"state" => state}})

    puts data['tweet_id']+" "+state
  end

b.stop