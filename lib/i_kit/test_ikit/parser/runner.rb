class IKit::TestIkit::Parser::Runner
  def initialize(search_string)
    @search_string = search_string
    @country       = 'RUS'
    @url           = 'https://certification.pmi.org/registry.aspx'
  end

  def save_resources!
    page = Nokogiri::HTML(get_html.to_s)
    attributes = IKit::TestIkit::Parser::Page.new(page).get_attributes
    attributes.each do |attrs|
      IKit::TestIkit::FormObjects::Person.new(attrs).save!
    end
  end

  def get_html
    uri = URI(@url)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    post_request = Net::HTTP::Post.new(uri.path, headers)
    
    post_request.body = request_body
    response = https.request(post_request)

    gz = Zlib::GzipReader.new(StringIO.new(response.body.to_s))    
    uncompressed_string = gz.read
  end

  def headers
    @headers ||= {
      'Origin' => 'https://certification.pmi.org',
      'Accept-Encoding' => 'gzip, deflate',
      'Accept-Language' => 'ru-RU,ru;q=0.8,en-US;q=0.6,en;q=0.4',
      'Upgrade-Insecure-Requests' => '1',
      'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.71 Safari/537.36',
      'Content-Type' => 'application/x-www-form-urlencoded',
      'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
      'Cache-Control' => 'no-cache',
      'Referer' => 'https://certification.pmi.org/registry.aspx',
      'Cookie' => 'ASP.NET_SessionId=ajdojm55hpf5yfnh3i1e2r45',
      'Connection' => 'keep-alive',
      }
  end

  def request_body
    request_body = ""
    data.each do |key, value|
      request_body += "#{key}=#{value}&"
    end
    request_body
  end

  def data
    @data ||= {
      '__EVENTTARGET' => nil,
      '__EVENTARGUMENT' => nil,
      '__VIEWSTATE' => "/wEPDwUKMTM0NTk1MDU2Mw9kFgICAw9kFgICAw8UKwADDwWCAUM7QzpQTUkuV2ViLkZyYW1ld29yay5EeW5hbWljUGxhY2Vob2xkZXIsIFBNSS5XZWIsIFZlcnNpb249Mi4wLjU3NjYuMjMyODksIEN1bHR1cmU9bmV1dHJhbCwgUHVibGljS2V5VG9rZW49bnVsbDtDb250ZW50UGxhY2Vob2xkZXIWAQ8FREM7VUM6QVNQLnJlZ2lzdHJ5X3JlZ2lzdHJ5Y29udGVudF9hc2N4Oi9SZWdpc3RyeTtkcGhfUmVnaXN0cnlDb250ZW50FgBkZBYCZg9kFgJmD2QWBgIBDw8WAh4EVGV4dAUBYWRkAgcPEGQPFvgBZgIBAgICAwIEAgUCBgIHAggCCQIKAgsCDAINAg4CDwIQAhECEgITAhQCFQIWAhcCGAIZAhoCGwIcAh0CHgIfAiACIQIiAiMCJAIlAiYCJwIoAikCKgIrAiwCLQIuAi8CMAIxAjICMwI0AjUCNgI3AjgCOQI6AjsCPAI9Aj4CPwJAAkECQgJDAkQCRQJGAkcCSAJJAkoCSwJMAk0CTgJPAlACUQJSAlMCVAJVAlYCVwJYAlkCWgJbAlwCXQJeAl8CYAJhAmICYwJkAmUCZgJnAmgCaQJqAmsCbAJtAm4CbwJwAnECcgJzAnQCdQJ2AncCeAJ5AnoCewJ8An0CfgJ/AoABAoEBAoIBAoMBAoQBAoUBAoYBAocBAogBAokBAooBAosBAowBAo0BAo4BAo8BApABApEBApIBApMBApQBApUBApYBApcBApgBApkBApoBApsBApwBAp0BAp4BAp8BAqABAqEBAqIBAqMBAqQBAqUBAqYBAqcBAqgBAqkBAqoBAqsBAqwBAq0BAq4BAq8BArABArEBArIBArMBArQBArUBArYBArcBArgBArkBAroBArsBArwBAr0BAr4BAr8BAsABAsEBAsIBAsMBAsQBAsUBAsYBAscBAsgBAskBAsoBAssBAswBAs0BAs4BAs8BAtABAtEBAtIBAtMBAtQBAtUBAtYBAtcBAtgBAtkBAtoBAtsBAtwBAt0BAt4BAt8BAuABAuEBAuIBAuMBAuQBAuUBAuYBAucBAugBAukBAuoBAusBAuwBAu0BAu4BAu8BAvABAvEBAvIBAvMBAvQBAvUBAvYBAvcBFvgBEAUQU2VsZWN0IGEgQ291bnRyeQUBMGcQBQtBZmdoYW5pc3RhbgUDQUZHZxAFDsOFbGFuZCBJc2xhbmRzBQNBTEFnEAUHQWxiYW5pYQUDQUxCZxAFB0FsZ2VyaWEFA0RaQWcQBQ5BbWVyaWNhbiBTYW1vYQUDQVNNZxAFB0FuZG9ycmEFA0FORGcQBQZBbmdvbGEFA0FHT2cQBQhBbmd1aWxsYQUDQUlBZxAFCkFudGFyY3RpY2EFA0FUQWcQBRNBbnRpZ3VhIGFuZCBCYXJidWRhBQNBVEdnEAUJQXJnZW50aW5hBQNBUkdnEAUHQXJtZW5pYQUDQVJNZxAFBUFydWJhBQNBQldnEAUJQXVzdHJhbGlhBQNBVVNnEAUHQXVzdHJpYQUDQVVUZxAFCkF6ZXJiYWlqYW4FA0FaRWcQBQdCYWhhbWFzBQNCSFNnEAUHQmFocmFpbgUDQkhSZxAFCkJhbmdsYWRlc2gFA0JHRGcQBQhCYXJiYWRvcwUDQlJCZxAFB0JlbGFydXMFA0JMUmcQBQdCZWxnaXVtBQNCRUxnEAUGQmVsaXplBQNCTFpnEAUFQmVuaW4FA0JFTmcQBQdCZXJtdWRhBQNCTVVnEAUGQmh1dGFuBQNCVE5nEAUHQm9saXZpYQUDQk9MZxAFIEJvbmFpcmUsIFNpbnQgRXVzdGF0aXVzIGFuZCBTYWJhBQNCRVNnEAUWQm9zbmlhIGFuZCBIZXJ6ZWdvdmluYQUDQklIZxAFCEJvdHN3YW5hBQNCV0FnEAUNQm91dmV0IElzbGFuZAUDQlZUZxAFBkJyYXppbAUDQlJBZxAFHkJyaXRpc2ggSW5kaWFuIE9jZWFuIFRlcnJpdG9yeQUDSU9UZxAFFkJyaXRpc2ggVmlyZ2luIElzbGFuZHMFA1ZHQmcQBRFCcnVuZWkgRGFydXNzYWxhbQUDQlJOZxAFCEJ1bGdhcmlhBQNCR1JnEAUMQnVya2luYSBGYXNvBQNCRkFnEAUHQnVydW5kaQUDQkRJZxAFCENhbWJvZGlhBQNLSE1nEAUIQ2FtZXJvb24FA0NNUmcQBQZDYW5hZGEFA0NBTmcQBQpDYXBlIFZlcmRlBQNDUFZnEAUOQ2F5bWFuIElzbGFuZHMFA0NZTWcQBRhDZW50cmFsIEFmcmljYW4gUmVwdWJsaWMFA0NBRmcQBQRDaGFkBQNUQ0RnEAUFQ2hpbGUFA0NITGcQBQ9DaGluYSwgbWFpbmxhbmQFA0NITmcQBRBDaHJpc3RtYXMgSXNsYW5kBQNDWFJnEAUXQ29jb3MgKEtlZWxpbmcpIElzbGFuZHMFA0NDS2cQBQhDb2xvbWJpYQUDQ09MZxAFB0NvbW9yb3MFA0NPTWcQBRBDb25nbywgRGVtLiBSZXAuBQNDT0RnEAULQ29uZ28sIFJlcC4FA0NPR2cQBQxDb29rIElzbGFuZHMFA0NPS2cQBQpDb3N0YSBSaWNhBQNDUklnEAUOQ8O0dGUgZCdJdm9pcmUFA0NJVmcQBQdDcm9hdGlhBQNIUlZnEAUEQ3ViYQUDQ1VCZxAFCEN1cmHDp2FvBQNDVVdnEAUGQ3lwcnVzBQNDWVBnEAUOQ3plY2ggUmVwdWJsaWMFA0NaRWcQBQdEZW5tYXJrBQNETktnEAUIRGppYm91dGkFA0RKSWcQBQhEb21pbmljYQUDRE1BZxAFEkRvbWluaWNhbiBSZXB1YmxpYwUDRE9NZxAFB0VjdWFkb3IFA0VDVWcQBQVFZ3lwdAUDRUdZZxAFC0VsIFNhbHZhZG9yBQNTTFZnEAURRXF1YXRvcmlhbCBHdWluZWEFA0dOUWcQBQdFcml0cmVhBQNFUklnEAUHRXN0b25pYQUDRVNUZxAFCEV0aGlvcGlhBQNFVEhnEAUhRmFsa2xhbmQgSXNsYW5kcyAoSXNsYXMgTWFsdmluYXMpBQNGTEtnEAUNRmFyb2UgSXNsYW5kcwUDRlJPZxAFHkZlZGVyYXRlZCBTdGF0ZXMgb2YgTWljcm9uZXNpYQUDRlNNZxAFBEZpamkFA0ZKSWcQBQdGaW5sYW5kBQNGSU5nEAUGRnJhbmNlBQNGUkFnEAUNRnJlbmNoIEd1aWFuYQUDR1VGZxAFEEZyZW5jaCBQb2x5bmVzaWEFA1BZRmcQBRtGcmVuY2ggU291dGhlcm4gVGVycml0b3JpZXMFA0FURmcQBQVHYWJvbgUDR0FCZxAFBkdhbWJpYQUDR01CZxAFB0dlb3JnaWEFA0dFT2cQBQdHZXJtYW55BQNERVVnEAUFR2hhbmEFA0dIQWcQBQlHaWJyYWx0YXIFA0dJQmcQBQZHcmVlY2UFA0dSQ2cQBQlHcmVlbmxhbmQFA0dSTGcQBQdHcmVuYWRhBQNHUkRnEAUKR3VhZGVsb3VwZQUDR0xQZxAFBEd1YW0FA0dVTWcQBQlHdWF0ZW1hbGEFA0dUTWcQBQZHdWluZWEFA0dJTmcQBQ1HdWluZWEtQmlzc2F1BQNHTkJnEAUGR3V5YW5hBQNHVVlnEAUFSGFpdGkFA0hUSWcQBSFIZWFyZCBJc2xhbmQgYW5kIE1jRG9uYWxkIElzbGFuZHMFA0hNRGcQBQhIb25kdXJhcwUDSE5EZxAFCUhvbmcgS29uZwUDSEtHZxAFB0h1bmdhcnkFA0hVTmcQBQdJY2VsYW5kBQNJU0xnEAUFSW5kaWEFA0lORGcQBQlJbmRvbmVzaWEFA0lETmcQBRlJcmFuLCBJc2xhbWljIFJlcHVibGljIG9mBQNJUk5nEAUESXJhcQUDSVJRZxAFB0lyZWxhbmQFA0lSTGcQBQZJc3JhZWwFA0lTUmcQBQVJdGFseQUDSVRBZxAFB0phbWFpY2EFA0pBTWcQBQVKYXBhbgUDSlBOZxAFBkpvcmRhbgUDSk9SZxAFCkthemFraHN0YW4FA0tBWmcQBQVLZW55YQUDS0VOZxAFCEtpcmliYXRpBQNLSVJnEAUGS3V3YWl0BQNLV1RnEAUKS3lyZ3l6c3RhbgUDS0daZxAFBExhb3MFA0xBT2cQBQZMYXR2aWEFA0xWQWcQBQdMZWJhbm9uBQNMQk5nEAUHTGVzb3RobwUDTFNPZxAFB0xpYmVyaWEFA0xCUmcQBRZMaWJ5YW4gQXJhYiBKYW1haGlyaXlhBQNMQllnEAUNTGllY2h0ZW5zdGVpbgUDTElFZxAFCUxpdGh1YW5pYQUDTFRVZxAFCkx1eGVtYm91cmcFA0xVWGcQBQVNYWNhbwUDTUFDZxAFKk1hY2Vkb25pYSwgVGhlIEZvcm1lciBZdWdvc2xhdiBSZXB1YmxpYyBvZgUDTUtEZxAFCk1hZGFnYXNjYXIFA01ER2cQBQZNYWxhd2kFA01XSWcQBQhNYWxheXNpYQUDTVlTZxAFCE1hbGRpdmVzBQNNRFZnEAUETWFsaQUDTUxJZxAFBU1hbHRhBQNNTFRnEAUQTWFyc2hhbGwgSXNsYW5kcwUDTUhMZxAFCk1hcnRpbmlxdWUFA01UUWcQBQpNYXVyaXRhbmlhBQNNUlRnEAUJTWF1cml0aXVzBQNNVVNnEAUHTWF5b3R0ZQUDTVlUZxAFBk1leGljbwUDTUVYZxAFFE1vbGRvdmEsIFJlcHVibGljIG9mBQNNREFnEAUGTW9uYWNvBQNNQ09nEAUITW9uZ29saWEFA01OR2cQBQpNb250ZW5lZ3JvBQNNTkVnEAUKTW9udHNlcnJhdAUDTVNSZxAFB01vcm9jY28FA01BUmcQBQpNb3phbWJpcXVlBQNNT1pnEAUHTXlhbm1hcgUDTU1SZxAFB05hbWliaWEFA05BTWcQBQVOYXVydQUDTlJVZxAFBU5lcGFsBQNOUExnEAULTmV0aGVybGFuZHMFA05MRGcQBRROZXRoZXJsYW5kcyBBbnRpbGxlcwUDQU5UZxAFDU5ldyBDYWxlZG9uaWEFA05DTGcQBQtOZXcgWmVhbGFuZAUDTlpMZxAFCU5pY2FyYWd1YQUDTklDZxAFBU5pZ2VyBQNORVJnEAUHTmlnZXJpYQUDTkdBZxAFBE5pdWUFA05JVWcQBQ5Ob3Jmb2xrIElzbGFuZAUDTkZLZxAFC05vcnRoIEtvcmVhBQNQUktnEAUYTm9ydGhlcm4gTWFyaWFuYSBJc2xhbmRzBQNNTlBnEAUGTm9yd2F5BQNOT1JnEAUET21hbgUDT01OZxAFCFBha2lzdGFuBQNQQUtnEAUFUGFsYXUFA1BMV2cQBRNQYWxlc3RpbmUsIFN0YXRlIG9mBQNQU0VnEAUGUGFuYW1hBQNQQU5nEAUQUGFwdWEgTmV3IEd1aW5lYQUDUE5HZxAFCFBhcmFndWF5BQNQUllnEAUEUGVydQUDUEVSZxAFC1BoaWxpcHBpbmVzBQNQSExnEAUIUGl0Y2Fpcm4FA1BDTmcQBQZQb2xhbmQFA1BPTGcQBQhQb3J0dWdhbAUDUFJUZxAFC1B1ZXJ0byBSaWNvBQNQUklnEAUFUWF0YXIFA1FBVGcQBQhSw6l1bmlvbgUDUkVVZxAFB1JvbWFuaWEFA1JPVWcQBRJSdXNzaWFuIEZlZGVyYXRpb24FA1JVU2cQBQZSd2FuZGEFA1JXQWcQBRFTYWludCBCYXJ0aMOpbGVteQUDQkxNZxAFDFNhaW50IEhlbGVuYQUDU0hOZxAFFVNhaW50IEtpdHRzIGFuZCBOZXZpcwUDS05BZxAFC1NhaW50IEx1Y2lhBQNMQ0FnEAUaU2FpbnQgTWFydGluIChGcmVuY2ggcGFydCkFA01BRmcQBSBTYWludCBWaW5jZW50IGFuZCB0aGUgR3JlbmFkaW5lcwUDVkNUZxAFGVNhaW50LVBpZXJyZSBhbmQgTWlxdWVsb24FA1NQTWcQBQVTYW1vYQUDV1NNZxAFClNhbiBNYXJpbm8FA1NNUmcQBRhTw6NvIFRvbcOpIGFuZCBQcsOtbmNpcGUFA1NUUGcQBQxTYXVkaSBBcmFiaWEFA1NBVWcQBQdTZW5lZ2FsBQNTRU5nEAUGU2VyYmlhBQNTUkJnEAUKU2V5Y2hlbGxlcwUDU1lDZxAFDFNpZXJyYSBMZW9uZQUDU0xFZxAFCVNpbmdhcG9yZQUDU0dQZxAFGVNpbnQgTWFhcnRlbiAoRHV0Y2ggcGFydCkFA1NYTWcQBQhTbG92YWtpYQUDU1ZLZxAFCFNsb3ZlbmlhBQNTVk5nEAUPU29sb21vbiBJc2xhbmRzBQNTTEJnEAUHU29tYWxpYQUDU09NZxAFDFNvdXRoIEFmcmljYQUDWkFGZxAFLFNvdXRoIEdlb3JnaWEgYW5kIHRoZSBTb3V0aCBTYW5kd2ljaCBJc2xhbmRzBQNTR1NnEAULU291dGggS29yZWEFA0tPUmcQBQtTb3V0aCBTdWRhbgUDU1NEZxAFBVNwYWluBQNFU1BnEAUJU3JpIExhbmthBQNMS0FnEAUFU3VkYW4FA1NETmcQBQhTdXJpbmFtZQUDU1VSZxAFFlN2YWxiYXJkIGFuZCBKYW4gTWF5ZW4FA1NKTWcQBQlTd2F6aWxhbmQFA1NXWmcQBQZTd2VkZW4FA1NXRWcQBQtTd2l0emVybGFuZAUDQ0hFZxAFFFN5cmlhbiBBcmFiIFJlcHVibGljBQNTWVJnEAUaVGFpd2FuIChSZXB1YmxpYyBvZiBDaGluYSkFA1RXTmcQBQpUYWppa2lzdGFuBQNUSktnEAUcVGFuemFuaWEsIFVuaXRlZCBSZXB1YmxpYyBPZgUDVFpBZxAFCFRoYWlsYW5kBQNUSEFnEAULVGltb3ItTGVzdGUFA1RMU2cQBQRUb2dvBQNUR09nEAUHVG9rZWxhdQUDVEtMZxAFBVRvbmdhBQNUT05nEAUTVHJpbmlkYWQgYW5kIFRvYmFnbwUDVFRPZxAFB1R1bmlzaWEFA1RVTmcQBQZUdXJrZXkFA1RVUmcQBQxUdXJrbWVuaXN0YW4FA1RLTWcQBRhUdXJrcyBhbmQgQ2FpY29zIElzbGFuZHMFA1RDQWcQBQZUdXZhbHUFA1RVVmcQBRNVLlMuIFZpcmdpbiBJc2xhbmRzBQNWSVJnEAUGVWdhbmRhBQNVR0FnEAUHVWtyYWluZQUDVUtSZxAFFFVuaXRlZCBBcmFiIEVtaXJhdGVzBQNBUkVnEAUOVW5pdGVkIEtpbmdkb20FA0dCUmcQBQ1Vbml0ZWQgU3RhdGVzBQNVU0FnEAUkVW5pdGVkIFN0YXRlcyBNaW5vciBPdXRseWluZyBJc2xhbmRzBQNVTUlnEAUHVXJ1Z3VheQUDVVJZZxAFClV6YmVraXN0YW4FA1VaQmcQBQdWYW51YXR1BQNWVVRnEAUHVmF0aWNhbgUDVkFUZxAFCVZlbmV6dWVsYQUDVkVOZxAFCFZpZXQgTmFtBQNWTk1nEAURV2FsbGlzIGFuZCBGdXR1bmEFA1dMRmcQBQ5XZXN0ZXJuIFNhaGFyYQUDRVNIZxAFBVllbWVuBQNZRU1nEAUGWmFtYmlhBQNaTUJnEAUIWmltYmFid2UFA1pXRWcWAQK0AWQCCQ8QZA8WCWYCAQICAgMCBAIFAgYCBwIIFgkQBQNBbGwFATBnEAUDUE1QBQExZxAFBENBUE0FATJnEAUEUGdNUAUBM2cQBQdQTUktUk1QBQE0ZxAFBlBNSS1TUAUBNWcQBQdQTUktQUNQBQE2ZxAFBFBmTVAFATdnEAUHUE1JLVBCQQUBOGcWAWZkGAEFHl9fQ29udHJvbHNSZXF1aXJlUG9zdEJhY2tLZXlfXxYCBRxIZWFkZXIxJFBNSUxvZ2luU3RhdHVzJGN0bDAxBRxIZWFkZXIxJFBNSUxvZ2luU3RhdHVzJGN0bDAzGgUmBiXFpmaYvPPzXLYGz630RdU=",
      'Header1$SearchText' => nil,
      'dph_RegistryContent$tbSearch' => @search_string,
      'dph_RegistryContent$firstNameTextBox' => nil,
      'dph_RegistryContent$wcountry' => @country,
      'dph_RegistryContent$credentialDDL' => 0,
      'dph_RegistryContent$Button1' => 'Search',
    }
  end

end
