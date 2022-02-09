# Tron

This library is designed to implement Tron wallet functionality with the goal of supporting offline transaction signing and API interaction with FullNode.

## WIP

Currently it implements a small number of APIs (including interacting with TRC20 contracts), but unfortunately offline signatures have not been implemented for the time being. However, you can still run the node locally to support the signature function in the `easy_transfer_by_private` function.

## Usage

Example of transferring USDT (Nile network):

```elixir
iex> usdt = Tron.Contract.new "TXYZopYRdj2D9XRtbG411XZZ3kM5VkAeBf", "<YOUR_ADDRESS>"
%Tron.Contract{
  contract_address: "41eca9bc828a3005b9a3b909f2cc5c2a54794de05f",
  owner_address: "<YOUR_ADDRESS_HEX>"
}

iex(2)> Tron.Contract.easy_transfer_by_private usdt, "<YOUR_PRIVATE_KEY>", "TMA942pDiP7LsuhD7didyM1GpbwE9KisSU", 0.9
{:ok, "b4198c3871b8c12405004b27c46203ee3e244d5d06839f20a8d96bc404cb6e35"}
```

Note that the `easy_transfer_by_private` function here is implemented by calling different functions (create, sign, broadcast), where the signature requires the support of the local node.
