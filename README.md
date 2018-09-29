# Ruby Elsys Decoder

## Description
This is a library for Elsys [ERS lora device](https://www.elsys.se/en/ers/) for decoding Elsys payload.

This library rewritten in ruby from [javascript library](https://www.elsys.se/en/elsys-payload/) provided by Elsys.


## Usage

```
require './elsys'

# Takes the hex string from payload and translate to bytes
data = hexToBytes("0100fd024104004e0500070e21")

# Decodes
p DecodeElsysPayload(data)

```

## License
This project is licensed under the terms of the MIT license.
