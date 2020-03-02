require 'open-uri'
require 'pry'

class Scraper
  
  #attr_accessor :name, :location, :profile_url

  def self.scrape_index_page(index_url)
    #binding.pry
    document = Nokogiri::HTML.parse(open(index_url))
    arr_names = document.css("h4.student-name").map{|child| child.text}
    arr_locations = document.css("p.student-location").map{|child| child.text}
    arr_profile_urls = document.css("div.student-card a").map{|child| child.attributes.values[0].value}
    index_page_array = []
    i = 0 
    while i < arr_names.length do 
      index_page_array << {name: arr_names[i], location: arr_locations[i], profile_url: arr_profile_urls[i]}
      i += 1 
    end 
    index_page_array
  end

  def self.scrape_profile_page(profile_url)
    #binding.pry
    document = Nokogiri::HTML.parse(open(profile_url))
    social_media = document.css("div.social-icon-container a").map{|child| child.attributes.values[0].value}
    twitter = social_media.find{|media| media.match(/twitter/)}
    linkedin = social_media.find{|media| media.match(/linkedin/)}
    github = social_media.find{|media| media.match(/github/)}
    blog = social_media.find{|media| media.match(/twitter/) == nil && media.match(/linkedin/) == nil && media.match(/github/) == nil}
    profile_quote = document.css("div.profile-quote").text#.gsub("\"","")
    bio = document.css("div.description-holder p").text
    #binding.pry
    profile_page_hash = {
      :twitter=>twitter,
      :linkedin=>linkedin,
      :github=>github,
      :blog=>blog,
      :profile_quote=>profile_quote,
      :bio=> bio
    }
    profile_page_hash.delete_if{|key,value| value == nil}
    profile_page_hash
  end

end

