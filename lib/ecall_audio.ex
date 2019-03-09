defmodule Ecall.Audio do
  use GenServer
  require Logger
  @moduledoc """
  Capture and write audio from/to USB device.
  """
  defmodule State do
    @moduledoc false
    # from: pid of client (where the audio data is sent)
    # pid: pid of serial port process
    defstruct from: nil,
      pid: nil
  end
  @doc """
  Start up a Audio GenServer.
  """
  @spec start_link([term]) :: {:ok, pid} | {:error, term}
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  @doc """
  open a serial device able to receive and
  write audio
  """
  @spec open_device(GenServer.server(), binary, [term]) :: :ok | {:error, term}
  def open_device(pid, name, opts \\ []) do
    GenServer.call(pid, {:open, name, opts})  
  end

  @doc """
  write audio to serial port
  """
  @spec write(GenServer.server(), binary) :: :ok | {:error, term}
  def write(pid, data) do
    GenServer.call(pid, {:write, data})  
  end

  @doc """
  write audio to serial port
  """
  @spec read(GenServer.server()) :: {:ok, binary} | {:error, term}
  def read(pid) do
    GenServer.call(pid, :read, 15000)  
  end
  @doc """
  close the serial port 
  """
  @spec close_device(GenServer.server()) :: :ok | {:error, term}
  def close_device (pid) do
    GenServer.call(pid, :close)  
  end

  #gen_server callbacks
  def init([]) do
    case  Circuits.UART.start_link do
      {:ok, pid} ->
          state = %State{pid: pid}
          {:ok, state}
      {:error, cause} ->
        {:stop, cause}
    end
  end

  def handle_call({:open, name, opts}, {from_pid, _}, state) do
    options =  Keyword.merge([speed: 115200, active: true], opts)
    case Circuits.UART.open(state.pid, name, options) do
      :ok -> 
        new_state = %{state | from: from_pid}
        {:reply, :ok, new_state}
      ret -> 
        {:reply, ret, state}
    end
  end

  def handle_call(:close, _from, state) do
    response = Circuits.UART.close(state.pid)
    {:reply, response, state}
  end

  def handle_call({:write, data}, _from, state) do
    response = Circuits.UART.write(state.pid, data)
    {:reply, response, state}
  end

	def handle_call(:read, _from, state) do
    #Circuits.UART.flush(state.pid,:receive)
    response = Circuits.UART.read(state.pid,10000)
    {:reply, response, state}
  end
  def handle_info({:circuits_uart, _port, data}, state) do
    send(state.from, {:ecall_audio,data})
    {:noreply, state}
  end

    def typeof(self) do
        cond do
            is_float(self)    -> "float"
            is_number(self)   -> "number"
            is_atom(self)     -> "atom"
            is_boolean(self)  -> "boolean"
            is_binary(self)   -> "binary"
            is_function(self) -> "function"
            is_list(self)     -> "list"
            is_tuple(self)    -> "tuple"
            true              -> "idunno"
        end    
    end
end
