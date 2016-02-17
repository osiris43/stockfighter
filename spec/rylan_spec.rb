require 'rylan'
require 'order'

RSpec.describe Rylan do
  let(:client) {Rylan.new("TESTEX")}
  let(:order_data) {{
  "account" => "EXB123456",
  "venue" => "TESTEX",
  "symbol" => "FOOBAR",
  "price" => 25000,  #$250.00 -- probably ludicrously high
  "qty" => 100,
  "direction" => "buy",
  "orderType" => "limit"  # See the order docs for what a limit order is
}}
  it "checks for heartbeat" do
    expect(client.heartbeat).to eq(true)
  end

  it "checks a venue heartbeat" do
    expect(client.check_venue).to eq(true)
  end

  it "gets the orderbook" do
    book = client.check_orderbook_for("FOOBAR")
    expect(book.symbol).to eq("FOOBAR")
  end

  it "populates the bids in the orderbook" do
    book = client.check_orderbook_for("FOOBAR")
    expect(book.bids.count).to be > 0
  end

  it "buys a stock" do
    order = Order.new order_data
    order_result = client.place_order order
    expect(order_result["ok"]).to be(true)
  end

  it "gets a quote" do
    expect(client.get_quote("FOOBAR")).not_to be_nil
  end
end
