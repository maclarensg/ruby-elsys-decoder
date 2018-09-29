#!/usr/bin/env ruby

require 'bundler'
Bundler.require
require 'json'
require '../elsys'

# Create a http connection to firebase, run "bundle" before usage
conn = Faraday.new(url: "<firebase>" ) do |builder|
  builder.adapter Faraday.default_adapter
end

# Method to put decoded message in firebase
def update(conn, datahexstr)
  data = hexToBytes(datahexstr)
  resp = conn.put do |req|
    req.url "/sensor.json"
    req.headers['Content-Type'] = 'application/json'
    req.headers['Accept'] = 'application/json'
    req.body = DecodeElsysPayload(data).to_json
  end
  puts resp.status
end


# Takes the hex string from payload and translate to bytes
data = hexToBytes("0100fd024104004e0500070e21")
# Decodes
p DecodeElsysPayload(data)

# Sends the decoded payload to firebase in json
update(conn, "0100e302290400270506060308070d62")
