require 'babosa'

File.open('us_cities.csv', 'r') do |f1|
  File.open('us_cities_clean.csv', 'w') do |f2|  
    while line = f1.gets  
      begin
        f2.puts line.to_slug.to_ascii.to_s
      rescue
      end
    end  
  end
end  
  
