defmodule AudioTest do
  use ExUnit.Case
  @moduledoc """
  This module provides common setup code for unit tests  tty0tty
  is required. See https://github.com/freemed/tty0tty.
  """

  def audio_port() do
    System.get_env("ECALL_AUDIO_PORT")
  end

  def simulator_port() do
    System.get_env("ECALL_SIM_PORT")
  end

  def common_setup() do
    if is_nil(audio_port()) || is_nil(simulator_port()) do
      header = "Please define ECALL_AUDIO_PORT and ECALL_SIM_PORT in your
  environment (e.g. to ttyS0 ).\n\n"

      ports = Circuits.UART.enumerate()

      msg =
        case ports do
          [] -> header <> "No serial ports were found. Check your OS to see if they exist"
          _ -> header <> "The following ports were found: #{inspect(Map.keys(ports))}"
        end

      flunk(msg)
    end
    options = [speed: 115200, active: false]
    {:ok, uart} = Circuits.UART.start_link()
    case Circuits.UART.open(uart, simulator_port(), options) do
      :ok ->
        {:ok, sim_port: uart}
      {:error, reason} ->
        flunk(reason)
    end
  end

  def write_data(pid , data) when byte_size(data) >= 4 do
    <<msg::binary-size(4), rest::binary>> = data
    Circuits.UART.write(pid, msg)
    write_data(pid, rest)
  end

  def write_data(pid , data) when byte_size(data) > 0 do
    Circuits.UART.write(pid, data)
    write_data(pid, <<>>)
  end

  def write_data(pid , <<>>) do
    Circuits.UART.drain(pid)
  end
 end

