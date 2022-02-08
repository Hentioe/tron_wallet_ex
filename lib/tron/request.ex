defmodule Tron.Request do
  @moduledoc false

  alias Tron.Models.{ApiError, RequestError}

  @type error :: ApiError.t() | RequestError.t()
  @type method :: :post | :get
  @type content_type :: :json
  @type response :: map

  @spec call(String.t(), {method, content_type} | method, keyword) ::
          {:ok, response} | {:error, error}

  def call(endpoint, mc, opts \\ [])

  def call(endpoint, {:post, :json}, opts) do
    body = Keyword.get(opts, :body)
    json_body = Jason.encode!(body)

    endpoint
    |> HTTPoison.post(json_body)
    |> handle_httpsion_returns()
  end

  def call(endpoint, :get, _opts) do
    endpoint
    |> HTTPoison.get()
    |> handle_httpsion_returns()
  end

  @spec handle_httpsion_returns({:ok, HTTPoison.Response.t()} | {:error, error}) ::
          {:ok, response} | {:error, error}
  defp handle_httpsion_returns({:ok, resp}) do
    status_code = resp.status_code

    if status_code in [200] do
      data = Jason.decode!(resp.body)
      msg = data["Error"] || data["error"]

      if msg != nil do
        {:error, %ApiError{status: status_code, msg: msg}}
      else
        {:ok, data}
      end
    else
      {:error, %ApiError{status: status_code}}
    end
  end

  defp handle_httpsion_returns({:error, err}) do
    {:error, %RequestError{reason: err.reason, msg: HTTPoison.Error.message(err)}}
  end
end
