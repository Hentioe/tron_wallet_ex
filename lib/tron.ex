defmodule Tron do
  @moduledoc false

  alias Tron.{Request, Tools}
  # alias Tron.Models.{Transaction, TransferContract}

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
    body = %{
      transaction: %{
        raw_data: transaction["raw_data"],
        raw_data_hex: transaction["raw_data_hex"]
      },
      privateKey: private_key
    }

    Request.call("gettransactionsign", {:post, :json}, body: body)
  end

  def broadcast_transaction(raw_data, raw_data_hex, signature) do
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

  # @spec sign_transaction(Transaction.Raw.t() | map, String.t()) :: <<_::520>>
  # def sign_transaction(raw_data, privkey_base16) when is_struct(raw_data, Transaction.Raw) do
  #   hash = :crypto.hash(:sha256, Transaction.Raw.encode(raw_data))
  #   privkey = Base.decode16!(privkey_base16, case: :lower)

  #   {:ok, <<sig_r::32-bytes, sig_s::32-bytes>>, recovery} =
  #     :libsecp256k1.ecdsa_sign_compact(hash, privkey, :default, <<>>)

  #   Base.encode16(sig_r <> sig_s <> <<recovery>>, case: :lower)
  # end

  # def sign_transaction(%{"contract" => contract} = raw_data, privkey_base16)
  #     when is_map(raw_data) do
  #   contract =
  #     Enum.map(contract, fn c ->
  #       %{
  #         "parameter" => %{
  #           "type_url" => type_url,
  #           "value" => %{
  #             "amount" => amount,
  #             "owner_address" => owner_address,
  #             "to_address" => to_address
  #           }
  #         }
  #       } = c

  #       Transaction.Contract.new(
  #         type: Transaction.Contract.ContractType.value(:TransferContract),
  #         parameter:
  #           Google.Protobuf.Any.new(
  #             type_url: type_url,
  #             value:
  #               TransferContract.encode(
  #                 TransferContract.new(
  #                   amount: amount,
  #                   owner_address: owner_address,
  #                   to_address: to_address
  #                 )
  #               )
  #           )
  #       )
  #     end)

  #   expiration = raw_data["expiration"]
  #   ref_block_bytes = raw_data["ref_block_bytes"]
  #   ref_block_hash = raw_data["ref_block_hash"]
  #   timestamp = raw_data["timestamp"]

  #   raw_data =
  #     Transaction.Raw.new(
  #       contract: contract,
  #       expiration: expiration,
  #       ref_block_bytes: ref_block_bytes,
  #       ref_block_hash: ref_block_hash,
  #       timestamp: timestamp
  #     )

  #   sign_transaction(raw_data, privkey_base16)
  # end
end
