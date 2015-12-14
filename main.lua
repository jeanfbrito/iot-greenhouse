--- Config
SSID       = "Dark side of the Force"
PASSWORD   = "senhasupersecreta"
TIMEOUT    = 30000 -- 30s

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
	pin = 4
	status,temp,humi = dht.read(pin)
    print("leu")
	if( status == dht.OK ) then
        print("ok")
	    sendToTS = require('sendToTS')
		sendToTS.setKey('5DL2THYRD4ZTNPH2')
		valSet = sendToTS.setValue(1,temp) -- field number, data.  sendToTS returns a boolean, true if set successfully
		sendToTS.sendData(true) -- show debug msgs T/F, callback file to run when done
		sendToTS = nil
		package.loaded["sendToTS"]=nil -- these last two lines help free up memory
	end
end

--- Main
print("Setting up Wi-Fi connection..")
wifi.setmode(wifi.STATION)
wifi.sta.config(SSID, PASSWORD)

-- print "hello world" every 1000ms
tmr.alarm(0, TIMEOUT, 1, function() 
    print("hello world")
     if wifi.sta.status() == STAMODE.STATION_GOT_IP then 
        print("Station: connected! IP: " .. wifi.sta.getip())
        sendTemp()
     end
end )
