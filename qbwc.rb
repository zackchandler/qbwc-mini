require 'rubygems'
require 'sinatra'
require 'hpricot'
require 'fast_xs'

class NilClass
  def fast_xs
    ''
  end
end

post '/api' do
  content_type 'text/xml'

  payload = Hpricot.uxs(request.body.read)
  doc = Hpricot.XML(payload)
  api_call = doc.containers[0].containers[0].containers[0].name.split(':').last
  
  # log request
  puts ''
  puts "========== #{api_call}  =========="
  puts payload
  
  case api_call
  when 'serverVersion'
    erb :serverVersion
  when 'clientVersion'
    erb :clientVersion
  when 'authenticate'
    @token = 'abc123'
    erb :authenticate
  when 'sendRequestXML'
    @qbxml = <<-XML
<?xml version="1.0" ?>
<?qbxml version="5.0" ?>
<QBXML>
  <QBXMLMsgsRq onError="continueOnError">
    <CustomerQueryRq requestID="1">
      <MaxReturned>10</MaxReturned>
      <IncludeRetElement>Name</IncludeRetElement>
    </CustomerQueryRq>
  </QBXMLMsgsRq>
</QBXML>
XML
    erb :sendRequestXML
  when 'receiveResponseXML'
    (doc/'CustomerRet').each do |node|
      puts "Customer: #{node.innerText.strip}"
    end
    @result = 100
    erb :receiveResponseXML
  when 'getLastError'
    @message = 'An error occurred'
    erb :getLastError
  when 'connectionError'
    @message = 'done'
    erb :connectionError
  when 'closeConnection'
    @message = 'OK'
    erb :closeConnection
  else
    ''
  end
end