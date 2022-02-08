defmodule Tron do
  @moduledoc false

  alias Tron.{Request, Tools}

  def create_transaction(to_address, owner_address, amount) do
    endpoint = "https://nile.trongrid.io/wallet/createtransaction"

    to_address =
      if String.length(to_address) == 42 do
        to_address
      else
        Tools.base58_to_hex(to_address)
      end

    owner_address =
      if String.length(owner_address) == 42 do
        owner_address
      else
        Tools.base58_to_hex(owner_address)
      end

    body = %{to_address: to_address, owner_address: owner_address, amount: amount}

    Request.call(endpoint, {:post, :json}, body: body)
  end

  def get_transaction_sign(transaction, private_key) do
    endpoint = "https://nile.trongrid.io/wallet/gettransactionsign"

    body = %{
      transaction: %{
        raw_data: transaction["raw_data"],
        raw_data_hex: transaction["raw_data_hex"]
      },
      privateKey: private_key
    }

    Request.call(endpoint, {:post, :json}, body: body)
  end

  def broadcast_transaction(raw_data, raw_data_hex, signature) do
    endpoint = "https://nile.trongrid.io/wallet/broadcasttransaction"

    body = %{
      raw_data: raw_data,
      raw_data_hex: raw_data_hex,
      signature: signature
    }

    Request.call(endpoint, {:post, :json}, body: body)
  end

  def easy_transfer_by_private(private_key, to_address, amount) do
    owner_address = get_address(private_key)

    with {:ok, transaction} <- create_transaction(to_address, owner_address, amount),
         {:ok, %{"signature" => signature}} <-
           Tron.get_transaction_sign(transaction, private_key),
         {:ok, %{"result" => true, "txid" => txid}} <-
           Tron.broadcast_transaction(
             transaction["raw_data"],
             transaction["raw_data_hex"],
             signature
           ) do
      {:ok, txid}
    else
      e -> e
    end
  end

  def get_address(privkey_base16, _hex \\ true) do
    <<privkey::32-bytes>> = Base.decode16!(privkey_base16, case: :lower)
    {:ok, <<4, pubkey::64-bytes>>} = :libsecp256k1.ec_pubkey_create(privkey, :uncompressed)
    <<_::12-bytes, address::20-bytes>> = ExSha3.keccak_256(pubkey)

    Base.encode16(<<0x41, address::bytes>>)
  end
end
