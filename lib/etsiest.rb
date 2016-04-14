require "etsiest/version"
require "sinatra/base"
require "etsy"
require "pry"

Etsy.api_key = ENV["ETSY_KEY"] # this is where we pull the api key from the command line

module Etsiest
  class Etsiest < Sinatra::Application
  	get "/search" do
		query = params["q"]
		# Here is where we get data from Etsy's API

		response = Etsy::Request.get('/listings/active', :includes => ['Images', 'Shop'], :keywords => query)

		# Here is where we pass that data to the ERB template to be turned into HTML  		
		# NOTE how we call ".result" on the response from Etsy
		# The Etsy gem returns a Etsy::Request object, not a hash
		# To be able to get the *data* we want and loop over it
		# in the ERB template, I need to pull the data out of the
		# Etsy::Request instance. This "result" method works best.
		erb :index, locals: { items: response.result, query: query }
	end

	run! if app_file == $0

  	end
end
