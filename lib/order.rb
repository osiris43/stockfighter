class Order
  attr_reader :account, :symbol, :qty, :direction, :orderType, :venue, :price

  def initialize data
    @account = data["account"]
    @symbol = data["symbol"]
    @qty= data["qty"]
    @direction= data["direction"]
    @orderType= data["orderType"]
    @venue = data["venue"]
    @price = data["price"]
  end

  def to_json(*a)
    {
      "account" => @account,
      "symbol" => @symbol,
      "qty" => @qty,
      "direction" => @direction,
      "orderType" => @orderType,
      "venue" => @venue,
      "price" => @price,
    }.to_json(*a)
  end

  def self.create acct, sym, qty, dir, type, venue, price
    order = {
      "account" => acct,
      "venue" => venue,
      "symbol" => sym,
      "price" => price,  #$250.00 -- probably ludicrously high
      "qty" => qty,
      "direction" => dir,
      "orderType" => type  # See the order docs for what a limit order is
    }
    Order.new order
  end
end
