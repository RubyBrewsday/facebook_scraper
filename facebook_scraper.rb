
require 'csv'
require 'roo'
require 'open-uri'
require 'json'
require 'google_drive'
puts "Starting the compilation_process"
# client = IronWorkerNG::Client.new(:token => "LTi53aYyGiqSkox74And6fp9YAg", :project_id => "542325ab948df60009000031")



# master_file = Roo::Google.new("1hKKMMo6kBSYe1FBWpD93UVtq_4CXQGMYRf6dVD9ZErQ",{ :user => "poage.michael.cu@gmail.com", :password => "marlborojoe"})

ids = []
nice_file = Roo::Google.new(ARGV[0], {:user => "mike@usefedora.com", :password => "poageybear" })
nice_file.each do |row|
  ids  << row[0].to_i
end
CSV.open("#{ARGV[1]}.csv", "w+") do |row|
  row << ["ID", "FIRST NAME", "LAST NAME", "NAME", "USERNAME", "GENDER"]
  total_time = 0.0
  ids.each do |id|
    start_time = Time.now
    begin
      result = JSON.parse(open("https://graph.facebook.com/#{id.to_s}").read)
      if result['username']
        row_data = [result['id'], result['first_name'], result['last_name'], result['name'], result['username'] + "@facebook.com", result['gender']]
        puts row_data.join(' ')
        row << row_data
      end
      sleep(1.1)
    rescue Exception => e
      puts e
      puts "bad url for user #{id}"
      sleep(2)
      next
    end
    end_time = Time.now
    puts "Snatch and Grab time (minus delay) = " + (end_time - start_time - 1.1).to_s
    total_time += (end_time - start_time - 1)
  end
  puts "Average time per scrape: " + (total_time / ids.size).to_s
end

session = GoogleDrive.login("mike@usefedora.com", "poageybear")
session.upload_from_file("#{ARGV[1]}.csv", "#{ARGV[1]}.csv", :convert => false)

# puts "ID list compiled. Creating new file for #{ids.size} users"

# CSV.open("master_ids_facebook.csv", "w+") do |row|
#   row << ["ID", "FIRST NAME", "LAST NAME", "NAME", "USERNAME", "GENDER"]
#   ids.each do |id|
#     begin
#       result = JSON.parse(open("https://graph.facebook.com/#{id}").read)
#       row << [result['id'], result['first_name'], result['last_name'], result['name'], result['username'] + "@facebook.com", result['gender']]
#     rescue
#       puts "bad url for user #{id}"
#       next
#     end
#   end
# end

# CSV.foreach("Authors1/#{file}") do |row|
#   ids << row[0]
# end
