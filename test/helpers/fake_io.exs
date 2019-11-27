defmodule FakeIO do
  # use Agent
  # @me __MODULE__

  # def start_link(_opts) do
  #   Agent.start_link(fn -> %{} end, name: @me)
  # end

  # def gets(_), do: "ok"
  def puts(string), do: send(self(), {:printing, string})
end
