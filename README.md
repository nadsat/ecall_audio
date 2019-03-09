# Ecall.Audio
[![Build Status](https://travis-ci.org/nadsat/ecall_audio.svg?branch=master)](https://travis-ci.org/nadsat/ecall_audio)

Simple wrapper over circuits_uart to read and write audio over serial devices
## Example use
 The example is using a modem SIM7600

```elixir
iex(1)> {:ok, pid} = Ecall.Audio.start_link
{:ok, #PID<0.199.0>}
iex(2)> Ecall.Audio.open_device(pid, "ttyUSB4")
:ok
iex(3)> flush
{:ecall_audio,
 <<0, 0, 0, 0, 1, 0, 0, 0, 255, 255, 0, 0, 255, 255, 1, 0, 1, 0, 1, 0, 3, 0, 2,
   0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 255, 255, 0, 0, 1, 0, 0, 0, 1, 0, 2, 0, 1,
   0, ...>>}
{:ecall_audio,
 <<0, 0, 255, 255, 0, 0, 0, 0, 0, 0, 255, 255, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0,
   0, 0, 0, 2, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0,
   ...>>}
iex(4)> Ecall.Audio.close_device(pid)
:ok
```

handling the phone call using minicom (an incomming call)

```
+CLIP: "+56777777777",145,,,,0
ata
+CRING: VOICE

+CLIP: "+56777777777",145,,,,0

VOICE CALL: BEGIN

OK
AT+CPCMREG=1 
OK

VOICE CALL: END: 000009

NO CARRIER
AT+CPCMREG=0 
OK

```
