#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'
require 'json'
require 'httparty'

# This allows us to accept requests from devices other than local host
set :bind, '0.0.0.0'
 

# This is our https://relay-demo.herokuapp.com  route
get '/' do
	erb :index # Load the template  views/index.erb
end
# 
post '/relay/:relay_number' do
	json = JSON.parse request.body.read

	relay = params[:relay_number]
	state = json["state"]
	access_token = json["access_token"]
	device_id = json["device_id"]

	puts "\n\n"
	puts "Relay #{relay}"
	puts "State #{state}"
	puts "Access token  #{access_token}"
	puts "Device ID #{device_id}"
	puts "\n\n"

	set_relay(relay,state,device_id,access_token)

	"Relay #{relay} the state is #{state}" 
end

# This is our https://relay-demo.herokuapp.com/settings route 
get '/settings' do
	erb :settings # Load the template views/settings.erb
end


def set_relay(relay, state, device_id, access_token)
  @result = HTTParty.post("https://api.particle.io/v1/devices/#{device_id}/relay_#{relay}?access_token=#{access_token}",
                          :body => { "args" => "#{state}"},
                          :headers => { 'Content-Type' => 'application/x-www-form-urlencoded' } )
  puts @result.body
end