require 'bunny'
require 'json'
require 'websocket-client-simple'
class MarketMonitor
  attr_reader :account, :venue, :symbol

  def initialize
    @account = "BR48559330"
    @symbol = "UZUG"
    @venue = "LMBAEX"
  end

  def monitor
    ws = WebSocket::Client::Simple.connect "wss://api.stockfighter.io/ob/api/ws/#{@account}/venues/#{@venue}/tickertape/stocks/#{@stock}"
    ws.on :message do |msg|
      puts msg.data
    end

    ws.on :open do
      ws.send 'hello!!!'
    end

    ws.on :close do |e|
      p e
      exit 1
    end

    loop do
      ws.send STDIN.gets.strip
    end
  end
end
