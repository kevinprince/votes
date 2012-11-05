require 'bunny'
require 'active_support/json'

j = ActiveSupport::JSON
b = Bunny.new()

b.start

  b.exchange('')
  q = b.queue('to_index_elastic')

  File.open('/home/kevinprince/US_short.txt', 'r') do |f1|
    while line = f1.gets
      begin
        q.publish(line)
      rescue
      end
    end
  end

b.stop