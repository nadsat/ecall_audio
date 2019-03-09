Code.require_file("audio_test.exs", __DIR__)

defmodule SimpleAudioTest do
  use ExUnit.Case
  alias Ecall.Audio

  setup do
    AudioTest.common_setup()
  end

  test "read from serial audio", %{sim_port: uart} do
    full_path = Path.join([__DIR__, "fixtures", "pcm16b8khz.raw"])
    {:ok,data} = File.read(full_path)
    {:ok, pid} =  Audio.start_link 
    assert :ok = Audio.open_device(pid, AudioTest.audio_port(), active: false) 
    AudioTest.write_data(uart, data)
    {:ok, audio} = Audio.read(pid)
    assert data == audio
    assert :ok = Audio.close_device(pid) 
  end

  test "write to serial audio", %{sim_port: uart} do
    {:ok, pid} =  Audio.start_link 
    assert :ok = Audio.open_device(pid, AudioTest.audio_port(), active: false) 
    Audio.write(pid, "AB")
    assert {ok, "AB"} = Circuits.UART.read(uart)
    assert :ok = Audio.close_device(pid) 
  end
end
