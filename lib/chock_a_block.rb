require_relative 'rylan'
require_relative 'order'

account = "TLB14667959"
symbol = "CREL"
venue = "ZEOPEX"

order_data = {
  "account" => account,
  "venue" => venue,
  "symbol" => symbol,
  "price" => 0,
  "qty" => 0,
  "direction" => "buy",
  "orderType" => "limit"  # See the order docs for what a limit order is
}

1.times do
  client = Rylan.new venue
  quote = client.get_quote symbol

  puts "Quote: #{quote}"
  order_data["price"] = quote.ask
  order_data["qty"] = quote.askSize
  puts "Order Data: #{order_data}" 
  order = Order.new order_data
  response = client.place_order order
  sleep(3)
  result = client.check_order symbol, response["id"]
  puts result
  sleep(4)
end
