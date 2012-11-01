require 'bunny'
require 'active_support/json'
require 'mongo'
require 'classifier'


j = ActiveSupport::JSON
b = Bunny.new()

db = Mongo::Connection.new("127.0.0.1", 27017).db("election")
tweets = db.collection("tweets")

states = {  
  "AL" => {"AL", "Alabama"},
  "AK" => {"AK", "Alaska"},
  "AS" => {"AS", "American Samoa"},
  "AZ" => {"AZ", "Arizona"},
  "AR" => {"AR", "Arkansas"},
  "CA" => {"CA", "California"},
  "CO" => {"CO", "Colorado"},
  "CT" => {"CT", "Connecticut"},
  "DE" => {"DE", "Delaware"},
  "DC" => {"DC", "District of Columbia"},
  "FM" => {"FM", "Fed. States of Micronesia"},
  "FL" => {"FL", "Florida"},
  "GA" => {"GA", "Georgia"},
  "GU" => {"GU", "Guam"},
  "HI" => {"HI", "Hawaii"},
  "ID" => {"ID", "Idaho"},
  "IL" => {"IL", "Illinois"},
  "IN" => {"IN", "Indiana"},
  "IA" => {"IA", "Iowa"},
  "KS" => {"KS", "Kansas"},
  "KY" => {"KY", "Kentucky"},
  "LA" => {"LA", "Louisiana"},
  "ME" => {"ME", "Maine"},
  "MH" => {"MH", "Marshall Islands"},
  "MD" => {"MD", "Maryland"},
  "MA" => {"MA", "Massachusetts"},
  "MI" => {"MI", "Michigan"},
  "MN" => {"MN", "Minnesota"},
  "MS" => {"MS", "Mississippi"},
  "MO" => {"MO", "Missouri"},
  "MT" => {"MT", "Montana"},
  "NE" => {"NE", "Nebraska"},
  "NV" => {"NV", "Nevada"},
  "NH" => {"NH", "New Hampshire"},
  "NJ" => {"NJ", "New Jersey"},
  "NM" => {"NM", "New Mexico"},
  "NY" => {"NY", "New York"},
  "NC" => {"NC", "North Carolina"},
  "ND" => {"ND", "North Dakota"},
  "MP" => {"MP", "Northern Mariana Is."},
  "OH" => {"OH", "Ohio"},
  "OK" => {"OK", "Oklahoma"},
  "OR" => {"OR", "Oregon"},
  "PW" => {"PW", "Palau"},
  "PA" => {"PA", "Pennsylvania"},
  "PR" => {"PR", "Puerto Rico"},
  "RI" => {"RI", "Rhode Island"},
  "SC" => {"SC", "South Carolina"},
  "SD" => {"SD", "South Dakota"},
  "TN" => {"TN", "Tennessee"},
  "TX" => {"TX", "Texas"},
  "UT" => {"UT", "Utah"},
  "VT" => {"VT", "Vermont"},
  "VA" => {"VA", "Virginia"},
  "VI" => {"VI", "Virgin Islands"},
  "WA" => {"WA", "Washington"},
  "WV" => {"WV", "West Virginia"},
  "WI" => {"WI", "Wisconsin"},
  "WY" => {"WY", "Wyoming"}
}

lsi = Classifier::LSI.new

states.each do |key,value|
  lsi.add_item value[0], key
  lsi.add_item value[1], key
end

b.start
  q = b.queue('state_enriching')

  q.subscribe() do |msg|
    data = j.decode(msg[:payload])
    state = lsi.classify(data["user_location"])
    tweets.update({"_id" => data["_id"]}, {"$set" => {"state" => state}})
    puts data['tweet_id']+" "+state
  end

b.stop