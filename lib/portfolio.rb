require 'bunny'
require 'json'

class Portfolio
  attr_reader :balance

  def initialize
    @conn = Bunny.new
    @conn.start

    @ch = @conn.create_channel
    @exchange = @ch.fanout("stockfighter")
    @queue = @ch.queue("", :exclusive => true)
    @queue.bind(@exchange)
    @balance = 0
  end


  def listen
    puts "listening for buys and sells"
    begin
      @queue.subscribe(:block => true) do |delivery_info, properties, body|
        puts "Received position #{body}"
        position = JSON.parse(body)
        if position["direction"] == "buy"
          @balance -= (position["qty"] * position["price"])
          puts "bought"
        else
          @balance += (position["qty"] * position["price"]) 
          puts "sold"
        end

        puts "Current Balance: $#{@balance / 100}"
      end
    rescue Interrupt => 
      @ch.close
      @conn.close
    end

  end

end
