defmodule Eljiffy do
  @moduledoc """
  Documentation for Eljiffy.

  Eljiffy (Elixir Jiffy) is an Elixir wrapper around the erlang JSON nif library Jiffy.
  It also provides functions to convert json to maps directly rather than having to pass the option return_maps explicitly
  (https://github.com/davisp/jiffy) (decode!/1 and decode!/2)

  ### The opts parameter for `decode_proplist/2` is a list of terms:
  - `:return_maps` - Tell Jiffy to return objects using the maps data type on VMs that support it. This raises an error on VMs that don't support maps.
  - `null_term:` term - Returns the specified Term instead of null when decoding JSON. This is for people that wish to use undefined instead of null.
  - `:use_nil` - Returns the atom nil instead of null when decoding JSON. This is a short hand for `{:null_term, nil}`.
  - `:return_trailer` - If any non-whitespace is found after the first JSON term is decoded the return value of `decode_proplist/2` becomes `{:has_trailer, firstTerm, restData}`. This is useful to decode multiple terms in a single binary.
  - `:dedupe_keys` - If a key is repeated in a JSON object this flag will ensure that the parsed object only contains a single entry containing the last value seen. This mirrors the parsing beahvior of virtually every other JSON parser.
  - `:copy_strings` - Normaly when strings are decoded they are created as sub-binaries of the input data. With some workloads this can lead to an undeseriable bloating of memory when a few small strings in JSON keep a reference to the full JSON document alive. Setting this option will instead allocate new binaries for each string to avoid keeping the original JSON document around after garbage collection.
  - `bytes_per_red: n where n >= 0` - This controls the number of bytes that Jiffy will process as an equivalent to a reduction. Each 20 reductions we consume 1% of our allocated time slice for the current process. When the Erlang VM indicates we need to return from the NIF.
  - `bytes_per_iter: n where n >= 0` - Backwards compatible option that is converted into the `bytes_per_red` value.

  ### The opts parameter for `encode!/2` is a list of terms:
  - `:uescape` - Escapes UTF-8 sequences to produce a 7-bit clean output
  - `:pretty` - Produce JSON using two-space indentation
  - `:force_utf8` - Force strings to encode as UTF-8 by fixing broken surrogate pairs and/or using the replacement character to remove broken UTF-8 sequences in data.
  - `:use_nil` - Encode's the atom nil as null.
  - `:escape_forward_slashes` - Escapes the / character which can be useful when encoding URLs in some cases.
  - `bytes_per_red:` n - Refer to the decode options
  - `bytes_per_iter:` n - Refer to the decode options
  """

  @doc """
  Transforms a json string into a key/value list in EEP 18 format

  ## Examples
    iex> jsonData = ~s({\"people\": [{\"name\": \"Joe\"}, {\"name\": \"Robert\"}, {\"name\": \"Mike\"}]})
    iex> Eljiffy.decode_proplist(jsonData)
    {[
      {"people", [
        {[{"name", "Joe"}]},
        {[{"name", "Robert"}]},
        {[{"name", "Mike"}]}
      ]}
    ]}
  """
  def decode_proplist(data) do
    :jiffy.decode(data)
  end

  @doc """
  Does the same thing as `decode_proplist/1`, but accepts decode options (see [opts](#module-the-opts-parameter-for-decode-2-is-a-list-of-terms))
  """
  def decode_proplist(data, opts) do
    :jiffy.decode(data, opts)
  end

  @doc """
  Transforms a EEP 18 format key/value list or map into a json string

  Accepts encode options (see [opts](#module-the-opts-parameter-for-encode-2-is-a-list-of-terms))

  ## Examples
    iex> term = %{langs: [%{elixir: %{beam: :true}}, %{erlang: %{beam: :true}}, %{rust: %{beam: :false}}]}
    iex> Eljiffy.encode!(term)
    ~s({\"langs\":[{\"elixir\":{\"beam\":true}},{\"erlang\":{\"beam\":true}},{\"rust\":{\"beam\":false}}]})
  """
  def encode!(data, opts \\ []) do
    :jiffy.encode(data, opts)
  end

  @doc """
  Transforms a EEP 18 format key/value list or map into a json string

  Accepts encode options (see [opts](#module-the-opts-parameter-for-encode-2-is-a-list-of-terms))

  ## Examples
    iex> term = %{langs: [%{elixir: %{beam: :true}}, %{erlang: %{beam: :true}}, %{rust: %{beam: :false}}]}
    iex> Eljiffy.encode(term)
    {:ok, ~s({\"langs\":[{\"elixir\":{\"beam\":true}},{\"erlang\":{\"beam\":true}},{\"rust\":{\"beam\":false}}]})}

    iex> term = <<255>>
    iex> Eljiffy.encode(term)
    {:error, %ErlangError{original: {:invalid_string, <<255>>}}}
  """
  def encode(data, opts \\ []) do
    {:ok, encode!(data, opts)}
  rescue
    exception -> {:error, exception}
  end

  @doc """
  Transforms a json string into a map

  Accepts decode options (see [opts](#module-the-opts-parameter-for-decode-2-is-a-list-of-terms))

  ## Examples
    iex> jsonData = ~s({\"people\": [{\"name\": \"Joe\"}, {\"name\": \"Robert\"}, {\"name\": \"Mike\"}]})
    iex> Eljiffy.decode_maps(jsonData)
    %{"people" => [
      %{"name" => "Joe"},
      %{"name" => "Robert"},
      %{"name" => "Mike"}
    ]}
  """
  @doc since: "1.1.0"
  @deprecated "use decode!/2 instead"
  def decode_maps(data, opts \\ []) do
    :jiffy.decode(data, [:return_maps] ++ opts)
  end

  @doc """
  Transforms a json string into a map

  Accepts decode options (see [opts](#module-the-opts-parameter-for-decode-2-is-a-list-of-terms))

  ## Examples
    iex> jsonData = ~s({\"people\": [{\"name\": \"Joe\"}, {\"name\": \"Robert\"}, {\"name\": \"Mike\"}]})
    iex> Eljiffy.decode!(jsonData)
    %{"people" => [
      %{"name" => "Joe"},
      %{"name" => "Robert"},
      %{"name" => "Mike"}
    ]}
  """
  def decode!(data, opts \\ []) do
    :jiffy.decode(data, [:return_maps] ++ opts)
  end

  @doc """
  Transforms a json string into a map

  Accepts decode options (see [opts](#module-the-opts-parameter-for-decode-2-is-a-list-of-terms))

  ## Examples
    iex> jsonData = ~s({\"people\": [{\"name\": \"Joe\"}, {\"name\": \"Robert\"}, {\"name\": \"Mike\"}]})
    iex> Eljiffy.decode(jsonData)
    {:ok, %{"people" => [
      %{"name" => "Joe"},
      %{"name" => "Robert"},
      %{"name" => "Mike"}
    ]}}

    iex> jsonData = ~s(invalid_json)
    iex> Eljiffy.decode(jsonData)
    {:error, %ErlangError{original: {1, :invalid_json}}}
  """
  def decode(data, opts \\ []) do
    {:ok, decode!(data, [:return_maps] ++ opts)}
  rescue
    exception -> {:error, exception}
  end
end
