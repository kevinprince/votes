require 'bunny'
require 'active_support/json'
require 'mongo'

j = ActiveSupport::JSON
b = Bunny.new()

db = Mongo::Connection.new("127.0.0.1", 27017).db("election")
tweets = db.collection("tweets")

b.start

  q = b.queue('state_enriching')
  
    cursor = tweets.find()
    
    obj = cursor.next_document
    
    while obj
      data = {
        'id' => obj["_id"],
        'tweet_id' => obj["id"],
        'user_location' => obj["user"]["location"]
        'time_zone' => obj["user"]["time_zone"]
      }
      q.publish(j.encode(data))
      obj = cursor.next_document
    end


b.stop