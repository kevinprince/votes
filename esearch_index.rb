require 'tire'
require 'bunny'

b = Bunny.new()

Tire.index 'places' do
  delete
  create
end

Tire.index 'places' do
  b.start
    q = b.queue('to_index_elastic')

    q.subscribe() do |msg|
      row =  msg[:payload].split(',')
      store :id => row[0].strip, :name => row[1].strip, :state => row[2].strip, :timezone => row[3].strip
    end

  b.stop
end


Tire.index 'places' do

  create :mappings => {
          :places => {
      :properties => {
        :id       => { :type => 'string', :index => 'not_analyzed', :include_in_all => false },
        :title    => { :type => 'string', :boost => 2.0,            :analyzer => 'snowball'  },
        :state     => { :type => 'string', :analyzer => 'keyword'                             },
        :timezone  => { :type => 'string', :analyzer => 'keyword'                            }
      }
    }
  }

  refresh

end