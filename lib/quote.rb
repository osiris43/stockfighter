class Quote
  attr_reader :symbol, :venue, :bid, :ask, :askSize, :last, :bid, :bidSize
  
  def initialize json
    puts json
    @symbol = json["symbol"]
    @venue = json["venue"]
    @bid = json["bid"]
    @last = json["last"]
    @ask = json["ask"]
    @bid = json["bid"]
    @askSize = json["askSize"].to_i
    @bidSize = json["bidSize"].to_i
  end

  def midpoint
    if @ask.nil?
      return ((@bid + @last) / 2).to_i
    elsif @bid.nil?
      return ((@last + @ask) /2).to_i
    else
      return ((@bid + @ask) / 2).to_i
    end
  end
=begin
  {
    "ok": true,
    "symbol": "FAC",
    "venue": "OGEX",
    "bid": 5100, // best price currently bid for the stock
    "ask": 5125, // best price currently offered for the stock
    "bidSize": 392, // aggregate size of all orders at the best bid
    "askSize": 711, // aggregate size of all orders at the best ask
    "bidDepth": 2748, // aggregate size of *all bids*
    "askDepth": 2237, // aggregate size of *all asks*
    "last": 5125, // price of last trade
    "lastSize": 52, // quantity of last trade
    "lastTrade": "2015-07-13T05:38:17.33640392Z", // timestamp of last trade
    "quoteTime": "2015-07-13T05:38:17.33640392Z" // ts we last updated quote at (server-side)
}
=end
end
