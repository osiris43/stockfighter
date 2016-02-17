
class Orderbook
  attr_reader :venue, :symbol, :bids, :asks
  def initialize json
    @venue = json["venue"]
    @symbol = json["symbol"]
    @bids = json["bids"]
    @asks = json["asks"]
  end
end
