# encoding: utf-8
module ChinaSMS
  module Service
    module Emay
      extend self

      SEND_URL = "http://sdk4report.eucp.b2m.cn:8080/sdkproxy/sendsms.action"
      GET_URL = "http://sdk4report.eucp.b2m.cn:8080/sdkproxy/getmo.action"
      COMPANY_INFO_REGISTRATION_URL = "http://sdk4report.eucp.b2m.cn:8080/sdkproxy/registdetailinfo.action"
      CANCEL_REGISTRATION_URL = "http://sdk4report.eucp.b2m.cn:8080/sdkproxy/logout.action"
      CODE_REGISTRATION_URL = "http://sdk4report.eucp.b2m.cn:8080/sdkproxy/regist.action"

      def to(phone, content, options)
        phones = Array(phone).join(',')
        res = Net::HTTP.post_form(URI.parse(SEND_URL), cdkey: options[:username], password: options[:password], phone: phones, message: content)
        result res.body
      end

      def get(options)
        # res = Net::HTTP.post_form(URI.parse(GET_URL), cdkey: options[:username], password: options[:password])
        url = GET_URL + "?cdkey=#{options[:username]}&password=#{options[:password]}"
        res = Net::HTTP.get(URI.parse(url))
        res.body
      end

      def result(body)
        code = body.match(/.+error>(.+)\<\/error/)[1]
        {
          success: (code.to_i >= 0),
          code: code
        }
      end

      def code_register(options)
        res = Net::HTTP.post_form(URI.parse(CODE_REGISTRATION_URL), cdkey: options[:username], password: options[:password])
        res.body
      end

      def company_info_register(options)
        res = Net::HTTP.post_form(URI.parse(COMPANY_INFO_REGISTRATION_URL), options)
        result res.body
      end

      def cancel_register(username, password)
        res = Net::HTTP.post_form(URI.parse(CANCEL_REGISTRATION_URL), cdkey: username, password: password)
        result res.body
      end
    end
  end
end
