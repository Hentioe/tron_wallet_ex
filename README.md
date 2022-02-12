# Tron

This library is designed to implement Tron wallet functionality with the goal of supporting offline transaction signing and API interaction with FullNode.

## WIP

A small number of NodeFull APIs (which I personally use) have been added so far, looking forward to your needs. This library has implemented offline transaction signature, including the signature part of `easy_transfer_by_private` and `get_transaction_sign` functions are implemented offline and will not interact with any remote end.

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

If you find that the library is still buggy in the signing part, you can also configure a node that hosts the signing function.
