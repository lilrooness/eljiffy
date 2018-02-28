defmodule Eljiffy do
  @moduledoc """
  Documentation for Eljiffy.

  Eljiffy (Elixir Jiffy or El Jiffy) is an Elixir wrapper around the erlang json nif library Jiffy
  also provides functions to convert json to maps directly rather than having to pass the option return_maps explicitly
  (https://github.com/davisp/jiffy)

  The opts parameter for decode/2 is a list of terms:
  :return_maps - Tell Jiffy to return objects using the maps data type on VMs that support it. This raises an error on VMs that don't support maps.
  null_term: term - Returns the specified Term instead of null when decoding JSON. This is for people that wish to use undefined instead of null.
  :use_nil - Returns the atom nil instead of null when decoding JSON. This is a short hand for {:null_term, nil}.
  :return_trailer - If any non-whitespace is found after the first JSON term is decoded the return value of decode/2 becomes {:has_trailer, firstTerm, restData}. This is useful to decode multiple terms in a single binary.
  :dedupe_keys - If a key is repeated in a JSON object this flag will ensure that the parsed object only contains a single entry containing the last value seen. This mirrors the parsing beahvior of virtually every other JSON parser.
  :copy_strings - Normaly when strings are decoded they are created as sub-binaries of the input data. With some workloads this can lead to an undeseriable bloating of memory when a few small strings in JSON keep a reference to the full JSON document alive. Setting this option will instead allocate new binaries for each string to avoid keeping the original JSON document around after garbage collection.
  bytes_per_red: n where n >= 0 - This controls the number of bytes that Jiffy will process as an equivalent to a reduction. Each 20 reductions we consume 1% of our allocated time slice for the current process. When the Erlang VM indicates we need to return from the NIF.
  bytes_per_iter: n where n >= 0 - Backwards compatible option that is converted into the bytes_per_red value.

  The opts parameter for encode/2 is a list of terms:
  :uescape - Escapes UTF-8 sequences to produce a 7-bit clean output
  :pretty - Produce JSON using two-space indentation
  :force_utf8 - Force strings to encode as UTF-8 by fixing broken surrogate pairs and/or using the replacement character to remove broken UTF-8 sequences in data.
  :use_nil - Encode's the atom nil as null.
  :escape_forward_slashes - Escapes the / character which can be useful when encoding URLs in some cases.
  bytes_per_red: n - Refer to the decode options
  bytes_per_iter: n - Refer to the decode options
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
