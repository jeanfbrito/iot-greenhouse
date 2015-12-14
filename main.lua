--- Config
SSID       = "Dark side of the Force"
PASSWORD   = "senhasupersecreta"
TIMEOUT    = 30000 -- 30s
status,temp,humi,lux = 0
timesRunned = 0

--- Station modes
STAMODE = {
  STATION_IDLE             = 0,
  STATION_CONNECTING       = 1,
  STATION_WRONG_PASSWORD   = 2,
  STATION_NO_AP_FOUND      = 3,
  STATION_CONNECT_FAIL     = 4,
  STATION_GOT_IP           = 5
}

function sendTemp()
	timesRunned = timesRunned + 1
    print("ok")
    sendToTS = require('sendToTS')
    sendToTS.setKey('5DL2THYRD4ZTNPH2')
	valSet = sendToTS.setValue(1,temp) -- field number, data.  sendToTS returns a boolean, true if set successfully
	valSet = sendToTS.setValue(2,humi) -- field number, data.  sendToTS returns a boolean, true if set successfully
    valSet = sendToTS.setValue(3,lux) -- field number, data.  sendToTS returns a boolean, true if set successfully
    valSet = sendToTS.setValue(4,node.heap()) -- field number, data.  sendToTS returns a boolean, true if set successfully
	valSet = sendToTS.setValue(5,timesRunned) -- field number, data.  sendToTS returns a boolean, true if set successfully
    sendToTS.sendData(true) -- show debug msgs T/F, callback file to run when done
	sendToTS = nil
	package.loaded["sendToTS"]=nil -- these last two lines help free up memory
end

--- Main
print("Setting up Wi-Fi connection..")
wifi.setmode(wifi.STATION)
wifi.sta.config(SSID, PASSWORD)

-- print "hello world" every 1000ms
tmr.alarm(0, TIMEOUT, 1, function() 
    print("temp:"..temp.." humi:"..humi.." lux:"..lux)
     if wifi.sta.status() == STAMODE.STATION_GOT_IP then 
        print("Station: connected! IP: " .. wifi.sta.getip())
        sendTemp()
     end
end )

tmr.alarm(4, 10000, 1, function()
    SDA_PIN = 6 -- sda pin, GPIO12
    SCL_PIN = 5 -- scl pin, GPIO14
    bh1750 = require("bh1750")
    bh1750.init(SDA_PIN, SCL_PIN)
    bh1750.read()
    lux = bh1750.getlux()
    lux = lux / 100
    lux = tonumber(string.format("%.2f",lux))
    --print("lux: "..lux)
    -- release module
    bh1750 = nil
    package.loaded["bh1750"]=nil
end )

tmr.alarm(2, 10000, 1, function()
    pin = 4
	status,temp,humi = dht.read(pin)
end)
