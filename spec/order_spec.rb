require 'order'

RSpec.describe Order do
  it "creates a new order" do
    o = Order.create "account", "sym", 1, "buy", "limit", "venue", 4000
    expect(o).not_to be_nil
    expect(o.symbol).to eq("sym")
  end
end
