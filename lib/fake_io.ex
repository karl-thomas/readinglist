defmodule FakeIO do
  use Agent
  @me __MODULE__
  @response_key "RESPONSE"
  @counter_key "COUNTER"

  def start_link(_opts) do
    Agent.start_link(fn -> %{} end, name: @me)
  end

  # set response of gets/1
  def set_response(value) do
    Agent.update(@me, &Map.put(&1, @response_key, value))
  end

  def increment_call_count do
    current_value = gets_call_count()
    Agent.update(@me, &Map.put(&1, @counter_key, current_value + 1))
  end

  def gets_call_count do
    Agent.get(@me, &Map.get(&1, @counter_key)) || 0
  end

  @doc """
    send a message to print the string argument, increment the call count, and return whatever is in the @response_key in the agent
  """
  def gets(string) do
    puts(string)
    increment_call_count()
    Agent.get(@me, &Map.get(&1, @response_key)) || "1"
  end

  @doc """
    send a message to print the string argument
  """
  def puts(string), do: send(self(), {:printing, string})
end
