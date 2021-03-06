print('init.lua')

dofile('config.lua')
dofile('pins.lua')

uart.setup(0, uart_baud, 8, 0, 1)
node.setcpufreq(node_cpu)

function d(f)
  dofile(f..'.lua')
end

function abort()
  tmr.stop(0)
end

a = abort

function res()
  node.restart()
end

function ip()
  print(wifi.sta.getip())
end

function apip()
  print(wifi.ap.getip())
end

function whoami() print(hostname) end
function ping(automated) if automated == 1 then print("!ok") else print("pong") end end
function safecall(codestr)
  status,err = pcall(function() loadstring(codestr)() end)
  if not status then print(err) end
  return status
end
function rpc(codestr)
  safecall(codestr)
  print("!ok_rpc")
end
function ls()
  l = file.list();
  for k,v in pairs(l) do
    print("name:"..k..", size:"..v)
  end
end

if wifi_disable == 1 then
  wifi.setmode(wifi.NULLMODE)
else
  wifi.setphymode(wifi_mode)
  if wifi_stationap == 1 then
    wifi.setmode(wifi.STATIONAP)
    d('wifi_client')
    d('ap')
  elseif wifi_sta == 1 then
    wifi.setmode(wifi.STATION)
    d('wifi_client')
  elseif wifi_ap == 1 then
    wifi.setmode(wifi.SOFTAP)
    d('ap')
  end
end

function out(pin)
  gpio.mode(pin, gpio.OUTPUT)
end

function lo(pin)
  gpio.write(pin, gpio.LOW)
end

function hi(pin)
  gpio.write(pin, gpio.HIGH)
end

if wait_wifi then
  CMDFILE = 'wait_wifi'
else
  CMDFILE = 'main'
end
tmr.alarm(0, 3000, 0, function() d(CMDFILE) end )

print('/init.lua')
