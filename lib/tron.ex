defmodule Tron do
  @moduledoc false

  alias Tron.{Request, Tools, Config}

  def create_transaction(to_address, owner_address, amount) do
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

    Request.call("createtransaction", {:post, :json}, body: body)
  end

  def get_transaction_sign(transaction, private_key) do
    if Config.hosted_signature() do
      body = %{
        transaction: %{
          raw_data: transaction["raw_data"],
          raw_data_hex: transaction["raw_data_hex"]
        },
        privateKey: private_key
      }

      Request.call("gettransactionsign", {:post, :json}, body: body)
    else
      sign_transaction_locally(transaction, private_key)
    end
  end

  def broadcast_transaction(
        %{"raw_data" => raw_data, "raw_data_hex" => raw_data_hex, "signature" => signature} =
          _transaction
      ) do
    body = %{
      raw_data: raw_data,
      raw_data_hex: raw_data_hex,
      signature: signature
    }

    Request.call("broadcasttransaction", {:post, :json}, body: body)
  end

  def easy_transfer_by_private(private_key, to_address, amount) do
    owner_address = get_address(private_key)

    with {:ok, transaction} <- create_transaction(to_address, owner_address, amount),
         {:ok, transaction} <- get_transaction_sign(transaction, private_key),
         {:ok, %{"result" => true, "txid" => txid}} <- Tron.broadcast_transaction(transaction) do
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

  @spec sign_transaction_locally(map, String.t()) :: {:ok, map}
  def sign_transaction_locally(%{"txID" => txid} = transaction, privkey_base16) do
    hash = Base.decode16!(txid, case: :lower)
    privkey = Base.decode16!(privkey_base16, case: :lower)

    {:ok, <<r::32-bytes, s::32-bytes>>, recovery_id} =
      :libsecp256k1.ecdsa_sign_compact(hash, privkey, :default, <<>>)

    r_hex = Base.encode16(r, case: :lower)
    s_hex = Base.encode16(s, case: :lower)

    end_str =
      case recovery_id do
        0 -> "1b"
        1 -> "1c"
      end

    signature = ["0x" <> r_hex <> s_hex <> end_str]

    {:ok, Map.put(transaction, "signature", signature)}
  end
end
