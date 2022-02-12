defmodule Tron.Config do
  @moduledoc false

  @spec network_url() :: String.t()
  def network_url do
    url = get(:network_url)

    if String.ends_with?(url, "/") do
      String.slice(url, 0..-2)
    else
      url
    end
  end

  @spec hosted_node_url :: String.t() | nil
  def hosted_node_url do
    get(:hosted_node_url)
  end

  @spec hosted_signature :: boolean
  def hosted_signature do
    get(:hosted_signature, false)
  end

  @spec get(atom, any) :: any
  defp get(key, default \\ nil) do
    Application.get_env(:tron, key, default)
  end
end
