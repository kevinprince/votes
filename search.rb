require 'tire'

s = Tire.search 'places' do
  query do
    string 'name:Square Point'
  end

end

puts s.results.first.state