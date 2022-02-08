defmodule Tron.Tools do
  @moduledoc false

  def base58_to_hex(base58_address) do
    decoded58 = Base58.decode(base58_address)

    decoded58 |> Base.encode16() |> String.slice(0..41) |> String.downcase()
  end
end
