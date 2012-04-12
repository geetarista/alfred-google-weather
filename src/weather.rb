#!/usr/bin/env ruby

require 'net/http'
require 'rexml/document'

location = URI.escape(ARGV[0] || 'cupertino, ca')
language = URI.escape(ARGV[1] || 'en')
unit = URI.escape(ARGV[2] || 'f')

url = "http://www.google.com/ig/api?weather=#{location}&hl=#{language}"

xml = Net::HTTP.get_response(URI.parse(url)).body

doc = REXML::Document.new(xml)

city = doc.elements['xml_api_reply/weather/forecast_information/city'].attributes['data']
condition = doc.elements['xml_api_reply/weather/current_conditions/condition'].attributes['data']
temp_f = doc.elements['xml_api_reply/weather/current_conditions/temp_f'].attributes['data']
temp_c = doc.elements['xml_api_reply/weather/current_conditions/temp_c'].attributes['data']
humidity = doc.elements['xml_api_reply/weather/current_conditions/humidity'].attributes['data']
icon = doc.elements['xml_api_reply/weather/current_conditions/icon'].attributes['data']
wind_condition = doc.elements['xml_api_reply/weather/current_conditions/wind_condition'].attributes['data']

if unit == 'f'
  temp = "#{temp_f} °F"
else
  temp = "#{temp_c} °C"
end

Net::HTTP.start("www.google.com") do |http|
  resp = http.get(icon)
  open("icon.png", "wb") do |file|
    file.write(resp.body)
  end
end

puts "#{condition} in #{city}"
puts "#{temp} at #{humidity}"
puts wind_condition
