require 'httparty'
require_relative 'orderbook'
require_relative 'quote'

class Rylan
  attr_reader :venue
  def initialize venue
    @venue = venue
    @base_url = "https://api.stockfighter.io/ob/api"
  end

  def heartbeat
    response = HTTParty.get("#{@base_url}/heartbeat")
    response.parsed_response["ok"]
  end

  def check_venue 
    response = HTTParty.get("#{@base_url}/venues/#{@venue}")
    response.parsed_response["ok"]
  end

  def check_orderbook_for stock
    response = HTTParty.get("#{@base_url}/venues/#{@venue}/stocks/#{stock}")
    Orderbook.new(response.parsed_response)
  end

  def place_order order
    response = HTTParty.post("#{@base_url}/venues/#{@venue}/stocks/#{order.symbol}/orders",
                            :body => order.to_json,
                            :headers => {"X-Starfighter-Authorization" => "bbe3fdcb48abf6e3e583f94c21228a0fd524c6bd"})
    
    response
  end

  def get_quote symbol
    puts "Getting a quote for #{symbol}"
    data = HTTParty.get("#{@base_url}/venues/#{@venue}/stocks/#{symbol}/quote")
    puts data
    return Quote.new(data)
  end

  def check_order symbol, id
    puts "checking on an order for #{symbol} with id #{id}"
    HTTParty.get("#{@base_url}/venues/#{@venue}/stocks/#{symbol}/orders/#{id}",
                 :headers => {"X-Starfighter-Authorization" => "bbe3fdcb48abf6e3e583f94c21228a0fd524c6bd"})
  end

  def cancel_order symbol, id
    puts "deleting order #{id}"
    HTTParty.delete("#{@base_url}/venues/#{@venue}/stocks/#{symbol}/orders/#{id}",
                 :headers => {"X-Starfighter-Authorization" => "bbe3fdcb48abf6e3e583f94c21228a0fd524c6bd"})

  end
end
