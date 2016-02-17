require 'bunny'

require_relative 'rylan'
require_relative 'order'

@account = "KAF21145499"
@symbol = "YEAY"
@venue = "YXEX"

order_data = {
  "account" => @account,
  "venue" => @venue,
  "symbol" => @symbol,
  "price" => 0,
  "qty" => 0,
  "direction" => "buy",
  "orderType" => "limit"  # See the order docs for what a limit order is
}

def rabbit_bootstrap
  conn = Bunny.new
  conn.start
  ch = conn.create_channel
  @exchange = ch.fanout('stockfighter')
end

@orders = []
@client = Rylan.new @venue

check_quote_counter = 0

rabbit_bootstrap

def publish_order order_status
  order_status["fills"].each do |fill|
    position = {"id" => order_status["id"], "qty" => fill["qty"],
                    "price" => fill["price"], "direction" => order_status["direction"]}
    @exchange.publish(position.to_json)
  end
end

def get_quote

  while true do
    quote = @client.get_quote @symbol
    break unless quote.askSize.nil?
  end
  quote
end
100.times do
  positions = []
  quote = get_quote

  order_data["direction"] = "buy"
  puts "Quote midpoint: #{quote.midpoint}"
  order_data["price"] = quote.bid + 10
  order_data["qty"] = quote.bidSize
  order = Order.new order_data
  response = @client.place_order order
  puts "Response: #{response}"
  @orders.push({ "id" => response["id"], "data" => response})
  
  while true do
    check_quote_counter += 1
    sleep(1)
    status = @client.check_order @symbol, @orders[0]["id"]
    if check_quote_counter == 10
      puts "Canceling order id #{@orders[0]["id"]}"
      status = @client.cancel_order order.symbol, @orders[0]["id"]
      puts "Cancel order response: #{status}"
    end

    next if status["open"] 
    publish_order status
    positions.push(status)
    # delete from the orders once filled.
    @orders.delete_if{|x| x["id"] == status["id"]}
    check_quote_counter = 0
    break
  end

  while true do
    # eventually try match a quote or order book entry
    quote = get_quote
    positions.each do |pos| 
      pos["fills"].each do |fill|

        # The price has fallen below the buying price or there was no ask
        if quote.ask.nil? or quote.ask < fill["price"]
          price = quote.bid + 20
        else
          price = quote.ask - 5
        end

        order_data["direction"] = "sell"
        order_data["price"] = price 
        order_data["qty"] = fill["qty"]
        puts "Sell Json: #{order_data}"
        order = Order.new order_data
        response = @client.place_order order
        puts "Sell initial response: #{response}"
        while true do
          status = @client.check_order @symbol, response["id"]
          next if status["open"]
          puts "Sell status: #{status}"
          publish_order status
          break
        end
      end
    end

    break
  end

  puts "main loop again"
end
