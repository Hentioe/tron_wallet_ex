defmodule Tron.Contract do
  @moduledoc false

  alias Tron.{Request, Tools}

  @enforce_keys [:contract_address, :owner_address]
  defstruct [:contract_address, :owner_address]

  def name(contract) when is_struct(contract, __MODULE__) do
    body = %{
      contract_address: contract.contract_address,
      function_selector: "name()",
      owner_address: contract.owner_address
    }

    Request.call("triggersmartcontract", {:post, :json}, body: body)
  end

  def symbol(contract) when is_struct(contract, __MODULE__) do
    body = %{
      contract_address: contract.contract_address,
      function_selector: "symbol()",
      owner_address: contract.owner_address
    }

    Request.call("triggersmartcontract", {:post, :json}, body: body)
  end

  def decimals(contract) when is_struct(contract, __MODULE__) do
    body = %{
      contract_address: contract.contract_address,
      function_selector: "decimals()",
      owner_address: contract.owner_address
    }

    Request.call("triggersmartcontract", {:post, :json}, body: body)
  end

  @doc """
  获取 TRC20 代币余额。
  """
  def balance_of(contract, address) do
    address_hex =
      if String.length(address) == 42 do
        address
      else
        Tools.base58_to_hex(address)
      end

    parameter = String.duplicate("0", 22) <> address_hex

    body = %{
      contract_address: contract.contract_address,
      function_selector: "balanceOf(address)",
      parameter: parameter,
      owner_address: contract.owner_address
    }

    Request.call("triggersmartcontract", {:post, :json}, body: body)
  end

  @doc """
  转账代币。
  """
  def transfer(contract, address, amount) do
    address_hex =
      if String.length(address) == 42 do
        address
      else
        Tools.base58_to_hex(address)
      end

    amount_dec = Decimal.from_float(amount / 1)

    amount_hex =
      amount_dec
      |> Decimal.mult(Decimal.new(1_000_000))
      |> Decimal.to_integer()
      |> Integer.to_string(16)

    address_parameter = String.duplicate("0", 22) <> address_hex
    uint256_parameter = String.duplicate("0", 64 - String.length(amount_hex)) <> amount_hex

    parameter = address_parameter <> uint256_parameter

    body = %{
      contract_address: contract.contract_address,
      function_selector: "transfer(address,uint256)",
      parameter: parameter,
      fee_limit: 100_000_000,
      call_value: 0,
      owner_address: contract.owner_address
    }

    Request.call("triggersmartcontract", {:post, :json}, body: body)
  end

  def easy_transfer_by_private(contract, private_key, to_address, amount) do
    with {:ok, %{"transaction" => transaction}} <-
           transfer(contract, to_address, amount),
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

  def new(contract_address, owner_address) do
    contract_address_hex =
      if String.length(contract_address) == 42 do
        contract_address
      else
        Tools.base58_to_hex(contract_address)
      end

    owner_address_hex =
      if String.length(owner_address) == 42 do
        owner_address
      else
        Tools.base58_to_hex(owner_address)
      end

    %__MODULE__{
      contract_address: contract_address_hex,
      owner_address: owner_address_hex
    }
  end

  def gen_nile_usdt(owner_address) do
    # Nile 网络的 usdt 合约地址: TXYZopYRdj2D9XRtbG411XZZ3kM5VkAeBf

    owner_address_hex =
      if String.length(owner_address) == 42 do
        owner_address
      else
        Tools.base58_to_hex(owner_address)
      end

    %__MODULE__{
      contract_address: Tools.base58_to_hex("TXYZopYRdj2D9XRtbG411XZZ3kM5VkAeBf"),
      owner_address: owner_address_hex
    }
  end

  def gen_nile_win(owner_address) do
    # Nile 网络的 win 合约地址: TU2T8vpHZhCNY8fXGVaHyeZrKm8s6HEXWe

    owner_address_hex =
      if String.length(owner_address) == 42 do
        owner_address
      else
        Tools.base58_to_hex(owner_address)
      end

    %__MODULE__{
      contract_address: Tools.base58_to_hex("TU2T8vpHZhCNY8fXGVaHyeZrKm8s6HEXWe"),
      owner_address: owner_address_hex
    }
  end
end
