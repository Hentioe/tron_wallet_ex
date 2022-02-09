defmodule Tron.Models do
  @moduledoc false

  defmodule ApiError do
    @moduledoc false

    defstruct [:status, :msg]

    @type t :: %__MODULE__{
            status: integer,
            msg: String.t()
          }
  end

  defmodule RequestError do
    @moduledoc false

    defstruct [:reason, :msg]

    @type t :: %__MODULE__{
            reason: atom,
            msg: String.t()
          }
  end

  # defmodule Transaction.Raw do
  #   @moduledoc false
  #   use Protobuf, syntax: :proto3

  #   @type t :: %__MODULE__{
  #           ref_block_bytes: String.t(),
  #           ref_block_hash: String.t(),
  #           expiration: integer,
  #           contract: [Tron.Models.Transaction.Contract.t()],
  #           timestamp: integer
  #         }
  #   defstruct [
  #     :ref_block_bytes,
  #     :ref_block_hash,
  #     :expiration,
  #     :contract,
  #     :timestamp
  #   ]

  #   field(:ref_block_bytes, 1, type: :bytes)
  #   field(:ref_block_hash, 4, type: :bytes)
  #   field(:expiration, 8, type: :int64)
  #   field(:contract, 11, repeated: true, type: Tron.Models.Transaction.Contract)
  #   field(:timestamp, 14, type: :int64)
  # end

  # defmodule Transaction.Contract.ContractType do
  #   @moduledoc false
  #   use Protobuf, enum: true, syntax: :proto3

  #   field(:AccountCreateContract, 0)
  #   field(:TransferContract, 1)
  #   field(:TransferAssetContract, 2)
  #   field(:VoteAssetContract, 3)
  #   field(:VoteWitnessContract, 4)
  #   field(:WitnessCreateContract, 5)
  #   field(:AssetIssueContract, 6)
  #   field(:WitnessUpdateContract, 8)
  #   field(:ParticipateAssetIssueContract, 9)
  #   field(:AccountUpdateContract, 10)
  #   field(:FreezeBalanceContract, 11)
  #   field(:UnfreezeBalanceContract, 12)
  #   field(:WithdrawBalanceContract, 13)
  #   field(:UnfreezeAssetContract, 14)
  #   field(:UpdateAssetContract, 15)
  #   field(:ProposalCreateContract, 16)
  #   field(:ProposalApproveContract, 17)
  #   field(:ProposalDeleteContract, 18)
  #   field(:SetAccountIdContract, 19)
  #   field(:CustomContract, 20)
  #   field(:CreateSmartContract, 30)
  #   field(:TriggerSmartContract, 31)
  #   field(:GetContract, 32)
  #   field(:UpdateSettingContract, 33)
  #   field(:ExchangeCreateContract, 41)
  #   field(:ExchangeInjectContract, 42)
  #   field(:ExchangeWithdrawContract, 43)
  #   field(:ExchangeTransactionContract, 44)
  # end

  # defmodule Transaction.Contract do
  #   @moduledoc false
  #   use Protobuf, syntax: :proto3

  #   @type t :: %__MODULE__{
  #           type: integer,
  #           parameter: Google.Protobuf.Any.t() | nil
  #         }
  #   defstruct [:type, :parameter]

  #   field(:type, 1, type: Tron.Models.Transaction.Contract.ContractType, enum: true)
  #   field(:parameter, 2, type: Google.Protobuf.Any)
  # end

  # defmodule TransferContract do
  #   @moduledoc false
  #   use Protobuf, syntax: :proto3

  #   @type t :: %__MODULE__{
  #           owner_address: String.t(),
  #           to_address: String.t(),
  #           amount: integer
  #         }
  #   defstruct [:owner_address, :to_address, :amount]

  #   field(:owner_address, 1, type: :bytes)
  #   field(:to_address, 2, type: :bytes)
  #   field(:amount, 3, type: :int64)
  # end

  # defmodule Authority do
  #   @moduledoc false
  #   use Protobuf, syntax: :proto3

  #   @type t :: %__MODULE__{
  #           account: Tron.Models.AccountId.t() | nil,
  #           permission_name: String.t()
  #         }
  #   defstruct [:account, :permission_name]

  #   field(:account, 1, type: Tron.Models.AccountId)
  #   field(:permission_name, 2, type: :bytes)
  # end

  # defmodule AccountId do
  #   @moduledoc false
  #   use Protobuf, syntax: :proto3

  #   @type t :: %__MODULE__{
  #           name: String.t(),
  #           address: String.t()
  #         }
  #   defstruct [:name, :address]

  #   field(:name, 1, type: :bytes)
  #   field(:address, 2, type: :bytes)
  # end
end
