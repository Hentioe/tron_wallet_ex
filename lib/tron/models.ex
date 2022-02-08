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
end
