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

  def local_api?(action) do
    Enum.member?(get(:local_api_list) || [], action)
  end

  def local_node_url do
    get(:local_node_url, "http://127.0.0.1:8090")
  end

  @spec get(atom, any) :: any
  defp get(key, default \\ nil) do
    Application.get_env(:tron, key, default)
  end
end
