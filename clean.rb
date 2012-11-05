require 'babosa'

# timezones = [
#   "Hawaii", #-10
#   "Alaska", #-9
#   "Pacific Time (US & Canada)", #-8
#   "Arizona", #-7
#   "Mountain Time (US & Canada)", #-7
#   "Central Time (US & Canada)", #-6
#   "Eastern Time (US & Canada)", #-5
#   "Indiana (East)" #-5
# ]

timezones = {
  'America/Adak' => 'Hawaii',
  'America/Anchorage' => 'Alaska',
  'America/Boise' => 'Mountain Time (US & Canada)',
  'America/Chicago' => 'Central Time (US & Canada)',
  'America/Denver' => 'Mountain Time (US & Canada)',
  'America/Detroit' => 'Eastern Time (US & Canada)',
  'America/Indiana/Indianapolis' => 'Eastern Time (US & Canada)',
  'America/Indiana/Knox' => 'Central Time (US & Canada)',
  'America/Indiana/Marengo' => 'Eastern Time (US & Canada)',
  'America/Indiana/Petersburg' => 'Eastern Time (US & Canada)',
  'America/Indiana/Tell_City' => 'Central Time (US & Canada)',
  'America/Indiana/Vevay' => 'Eastern Time (US & Canada)',
  'America/Indiana/Vincennes' => 'Eastern Time (US & Canada)',
  'America/Indiana/Winamac' => 'Eastern Time (US & Canada)',
  'America/Juneau' => 'Alaska',
  'America/Kentucky/Louisville' => 'Eastern Time (US & Canada)',
  'America/Kentucky/Monticello' => 'Eastern Time (US & Canada)',
  'America/Los_Angeles' => 'Pacific Time (US & Canada)',
  'America/Menominee' => 'Central Time (US & Canada)',
  'America/Metlakatla' => 'Pacific Time (US & Canada)',
  'America/New_York' => 'Eastern Time (US & Canada)',
  'America/Nome' => 'Alaska',
  'America/North_Dakota/Beulah' => 'Central Time (US & Canada)',
  'America/North_Dakota/Center' => 'Central Time (US & Canada)',
  'America/North_Dakota/New_Salem' => 'Central Time (US & Canada)',
  'America/Phoenix' => 'Mountain Time (US & Canada)',
  'America/Shiprock' => 'Mountain Time (US & Canada)',
  'America/Sitka' => 'Alaska',
  'America/Yakutat' => 'Alaska',
  'Pacific/Honolulu' => 'Hawaii'
}
File.open('/Users/kevin/Downloads/US/US.txt', 'r') do |f1|
  File.open('/Users/kevin/Downloads/US/US_short.txt', 'w') do |f2|
    while line = f1.gets
      begin
        row = line.split("\t")
        id = row[0]
        name = row[2]
        state = row[10]
        timezone = timezones[row[17]]
        f2.puts "#{id}, #{name}, #{state}, #{timezone}"
      rescue
      end
    end
  end
end


