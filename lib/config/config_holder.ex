defmodule Fua.Config.ConfigHolder do
  use Agent
  alias Fua.Config.AppConfig

  def start_link(conf = %AppConfig{}), do: Agent.start_link(fn -> conf end, name: __MODULE__)
  def conf(), do: Agent.get(__MODULE__, & &1)
end
