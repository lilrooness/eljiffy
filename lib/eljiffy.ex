defmodule Eljiffy do
  @moduledoc """
  Documentation for Eljiffy.

  Eljiffy (Elixir Jiffy or El Jiffy) is an Elixir wrapper around the erlang json nif library Jiffy
  also provides functions to convert json to maps directly rather than having to pass the option return_maps explicitly
  (https://github.com/davisp/jiffy)
  """

  @doc """
  decode

  ## Examples
      iex> jsonData = "{\"people\": [{\"name\": \"Joe\"}, {\"name\": \"Robert\"}, {\"name\": \"Mike\"}]}"
      iex> Eljiffy.decode(jsonData)
      {[
          {"people" [
	      {[{"name", "Joe"}]},
              {[{"name", "Robert"}]},
	      {[{"name", "Mike"}]}
	  ]}
      ]}
  """
  def decode(data) do
    :jiffy.decode(data)
  end

  def decode(data, opts) do
    :jiffy.decode(data, opts)
  end

  @doc """
  encode

  ## Examples
      iex> term = %{:langs => [%{:elixir => %{:beam => :true}}, %{:erlang => %{:beam => :true}}, %{:rust => %{:beam => :false}}]}
      iex> Eljiffy.encode(term)
      "{\"langs\":[{\"elixir\":{\"beam\":true}},{\"erlang\":{\"beam\":true}},{\"rust\":{\"beam\":false}}]}"
  """
  def encode(data) do
    :jiffy.encode(data)
  end

  def encode(data, opts) do
    :jiffy.encode(data, opts)
  end
  
  @doc """
  decode_maps

  ## Examples

      iex> jsonData = "{\"people\": [{\"name\": \"Joe\"}, {\"name\": \"Robert\"}, {\"name\": \"Mike\"}]}"
      iex> Eljiffy.decode_maps(jsonData)
        %{:people => [
            %{:name => "Joe"},
            %{:name => "Robert"},
            %{:name => "Mike"}
        ]}

  """
  def decode_maps(data) do
    :jiffy.decode(data, [:return_maps])
  end

  def decode_maps(data, opts) do
    :jiffy.decode(data, [:return_maps] ++ opts)
  end
end
