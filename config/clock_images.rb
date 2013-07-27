require "logger"
Log=Logger.new(STDERR)
DebugLog=Logger.new("./log/bounty.log")

require_relative "../config/boot"
require_relative "../config/environment"
 
require 'clockwork'
require 'net/http'

class GetCharacterImages
  def self.perform
    start = Time.now.to_i
    Character.all.each do |character|
      [ "32", "64", "128", "256"].each do |size|
        next if Rails.application.assets.find_asset("characters/#{character[:char_id]}_#{size}.jpg")
        
        Log.info "STARTED Getting image size: #{size} for: #{character[:name]}"  
        Net::HTTP.start("image.eveonline.com") do |http|
            resp = http.get("/Character/#{character[:char_id]}_#{size}.jpg")
            open("./app/assets/images/characters/#{character[:char_id]}_#{size}.jpg", "wb") do |file|
                file.write(resp.body)
            end
        end
        Log.info "FINISHED Getting image size: #{size} for: #{character[:name]}"  
      end
    end
    finish = Time.now.to_i
    duration = finish - start
    Log.info "COMPLETED Getting images for all characters, took: #{duration} seconds"
  end
end

class GetRatImages
  def self.perform
    start = Time.now.to_i
    Bounty.unique_rats.each do |rat|
      [ "32", "64" ].each do |size|
        next if Rails.application.assets.find_asset("rats/#{rat["_id"]}_#{size}.png")
        rat_name = Rat.where(:rat_id => rat["_id"]).first
        next if rat_name.nil?
        Log.info "STARTED Getting image size: #{size} for: #{Rat.where(:rat_id => rat["_id"]).first.rat_name}"  
        Net::HTTP.start("image.eveonline.com") do |http|
            resp = http.get("/Type/#{rat["_id"]}_#{size}.png")
            open("./app/assets/images/rats/#{rat["_id"]}_#{size}.png", "wb") do |file|
                file.write(resp.body)
            end
        end
        Log.info "FINISHED Getting image size: #{size} for: #{Rat.where(:rat_id => rat["_id"]).first.rat_name}"  
      end
    end
    finish = Time.now.to_i
    duration = finish - start
    Log.info "COMPLETED Getting images for all rats, took: #{duration} seconds"
  end
end

class GetCorpImages
  def self.perform
    start = Time.now.to_i
    Corp.each do |corp|
      [ "32", "64" ].each do |size|
        next if Rails.application.assets.find_asset("corps/#{corp.corp_id}_#{size}.png")
        Log.info "STARTED Getting image size: #{size} for: #{corp.name}"  
        Net::HTTP.start("image.eveonline.com") do |http|
            resp = http.get("/Corporation/#{corp.corp_id}_#{size}.png")
            open("./app/assets/images/corps/#{corp.corp_id}_#{size}.png", "wb") do |file|
                file.write(resp.body)
            end
        end
        Log.info "FINISHED Getting image size: #{size} for: #{corp.name}"  
      end
    end
    finish = Time.now.to_i
    duration = finish - start
    Log.info "COMPLETED Getting images for all corps, took: #{duration} seconds"
  end
end
 
module Clockwork
  every 2.hours, 'get_images' do
    GetCorpImages.perform
    GetCharacterImages.perform
    GetRatImages.perform
  end
end