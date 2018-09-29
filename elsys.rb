TYPE_TEMP         = 0x01 # temp 2 bytes -3276.8°C -->3276.7°C
TYPE_RH           = 0x02 # Humidity 1 byte   0-100%
TYPE_ACC          = 0x03 # acceleration 3 bytes X,Y,Z -128 --> 127 +/-63=1G
TYPE_LIGHT        = 0x04 # Light 2 bytes 0-->65535 Lux
TYPE_MOTION       = 0x05 # No of motion 1 byte   0-255
TYPE_CO2          = 0x06 # Co2 2 bytes 0-65535 ppm
TYPE_VDD          = 0x07 # VDD 2byte 0-65535mV
TYPE_ANALOG1      = 0x08 # VDD 2byte 0-65535mV
TYPE_GPS          = 0x09 # 3bytes lat 3bytes long binary
TYPE_PULSE1       = 0x0A # 2bytes relative pulse count
TYPE_PULSE1_ABS   = 0x0B # 4bytes no 0->0xFFFFFFFF
TYPE_EXT_TEMP1    = 0x0C # 2bytes -3276.5C-->3276.5C
TYPE_EXT_DIGITAL  = 0x0D # 1bytes value 1 or 0
TYPE_EXT_DISTANCE = 0x0E # 2bytes distance in mm
TYPE_ACC_MOTION   = 0x0F # 1byte number of vibration/motion
TYPE_IR_TEMP      = 0x10 # 2bytes internal temp 2bytes external temp -3276.5C-->3276.5C
TYPE_OCCUPANCY    = 0x11 # 1byte data
TYPE_WATERLEAK    = 0x12 # 1byte data 0-255
TYPE_GRIDEYE      = 0x13 # 65byte temperature data 1byte ref+64byte external temp
TYPE_PRESSURE     = 0x14 # 4byte pressure data (hPa)
TYPE_SOUND        = 0x15 # 2byte sound data (peak/avg)
TYPE_PULSE2       = 0x16 # 2bytes 0-->0xFFFF
TYPE_PULSE2_ABS   = 0x17 # 4bytes no 0->0xFFFFFFFF
TYPE_ANALOG2      = 0x18 # 2bytes voltage in mV
TYPE_EXT_TEMP2    = 0x19 # 2bytes -3276.5C-->3276.5C

class String
  def substr(n, m)
    self[n..m+n-1]
  end
end

def bin16dec(bin)
  num = bin & 0xFFFF
  num =- (0x010000 - num) if (0x8000 & num) != 0
  num
end

def bin8dec(bin)
  num = bin & 0xFF
  num =- (0x0100 - num) if (0x80 & num) != 0
  num
end

def hexToBytes(hex)
  bytes = []
  c = 0
  while c < hex.length
    bytes << (hex.substr(c,2)).to_i(16)
    c += 2
  end
  bytes
end

def DecodeElsysPayload(data)
  result = {}
  i = 0
  while (i < data.length)
    case data[i]
    when TYPE_TEMP # Temperature
      temp = (data[i+1]<<8)|(data[i+2])
      temp = bin16dec(temp)
      result[:temperature]=temp/10.0
      i+=2
    when TYPE_RH # Humidity
      rh=(data[i+1])
      result[:humidity]=rh
      i+=1
    when TYPE_ACC # Acceleration
      result[:x]=bin8dec(data[i+1])
      result[:y]=bin8dec(data[i+2])
      result[:z]=bin8dec(data[i+3])
      i+=3
    when TYPE_LIGHT # Light
      result[:light]=(data[i+1]<<8)|(data[i+2])
      i+=2
    when TYPE_MOTION # Motion sensor(PIR)
      result[:motion]=(data[i+1])
      i+=1
    when TYPE_CO2 # CO2
      result[:co2]=(data[i+1]<<8)|(data[i+2])
      i+=2
    when TYPE_VDD # Battery level
      result[:vdd]=(data[i+1]<<8)|(data[i+2])
      i+=2
    when TYPE_ANALOG1 # Analog input 1
      result[:analog1]=(data[i+1]<<8)|(data[i+2])
      i+=2
    when TYPE_GPS # gps
      result[:lat]=(data[i+1]<<16)|(data[i+2]<<8)|(data[i+3])
      result[:long]=(data[i+4]<<16)|(data[i+5]<<8)|(data[i+6])
      i+=6
    when TYPE_PULSE1 # Pulse input 1
      result[:pulse1]=(data[i+1]<<8)|(data[i+2])
      i+=2
    when TYPE_PULSE1_ABS # Pulse input 1 absolute value
      pulseAbs=(data[i+1]<<24)|(data[i+2]<<16)|(data[i+3]<<8)|(data[i+4])
      result[:pulseAbs]=pulseAbs
      i+=4
    when TYPE_EXT_TEMP1 # External temp
      temp=(data[i+1]<<8)|(data[i+2])
      temp=bin16dec(temp)
      result[:externalTemperature]=temp/10
      i+=2
    when TYPE_EXT_DIGITAL # Digital input
      result[:digital]=(data[i+1])
      i+=1
    when TYPE_EXT_DISTANCE # Distance sensor input
      result[:distance]=(data[i+1]<<8)|(data[i+2])
      i+=2
    when TYPE_ACC_MOTION # Acc motion
      result[:accMotion]=(data[i+1])
      i+=1
    when TYPE_IR_TEMP # IR temperature
      iTemp=(data[i+1]<<8)|(data[i+2])
      iTemp=bin16dec(iTemp)
      eTemp=(data[i+3]<<8)|(data[i+4])
      eTemp=bin16dec(eTemp)
      result[:irInternalTemperature]=iTemp/10
      result[:irExternalTemperature]=eTemp/10
      i+=4
    when TYPE_OCCUPANCY # Body occupancy
      result[:occupancy]=(data[i+1])
      i+=1
    when TYPE_WATERLEAK # Water leak
      result[:waterleak]=(data[i+1])
      i+=1
    when TYPE_GRIDEYE # Grideye data
      i+=65
    when TYPE_PRESSURE # External Pressure
      temp=(data[i+1]<<24)|(data[i+2]<<16)|(data[i+3]<<8)|(data[i+4])
      result[:pressure]=temp/1000
      i+=4
    when TYPE_SOUND # Sound
      result[:soundPeak]=data[i+1]
      result[:soundAvg]=data[i+2]
      i+=2
    when TYPE_PULSE2 # Pulse 2
      result[:pulse2]=(data[i+1]<<8)|(data[i+2])
      i+=2
    when TYPE_PULSE2_ABS # Pulse input 2 absolute value
      result[:pulseAbs2]=(data[i+1]<<24)|(data[i+2]<<16)|(data[i+3]<<8)|(data[i+4])
      i+=4
    when TYPE_ANALOG2 # Analog input 2
      result[:analog2]=(data[i+1]<<8)|(data[i+2])
      i+=2
    when TYPE_EXT_TEMP2 # External temp 2
      temp=(data[i+1]<<8)|(data[i+2])
      temp=bin16dec(temp)
      result[:externalTemperature2]=temp/10
      i+=2
    else # somthing is wrong with data
      i=data.length
    end #case
    i+=1
  end # while
  result
end