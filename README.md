# Wunder Challenge

Solution for Wunder Challenge made in Elixir using Streams.

## Install

```sh
mix deps.get
```

## Running Tests

```sh
mix test
```

## Running the code

Best way to run and interact with the code is in the iex Elixir REPL.
```sh
iex -S mix

Then you may use the module Main to interact with the code functionality.

```elixir
Main.happy_path()
```
This will load the cache with the pairs and coordinate data.

## Getting help

You can use the docstrings in the files to get some help about the API.
```elixir
h Main.pairs
```
