require 'json'
require 'httparty'
require 'date'

module Eodhd
  class Client

    def initialize(isin:, currency:, country: nil)
      @base_uri = 'https://eodhd.com/api/search'
      @key = Eodhd.configuration.api_key || raise(Eodhd::Error.new('API key is missing'))
      @format = :json
      @isin = isin
      @currency = currency
      @country = country
      @data = @price = @date = @name = nil # if nil then we haven't called eodhd yet
    end
    attr_reader :isin, :currency, :country

    def price
      return @price unless @price.nil?
      self.request if  @data.nil?

      price = 0.0
      count = 0

      @data.each do |r|
        if  r['Currency'] == @currency &&
            r['ISIN'] == @isin &&
            r['previousClose'].class == Float &&
            (@country.nil? || r['Country'] == @country)
          price += r['previousClose']
          count += 1
        end
      end
      price /= count if count > 1
      @price = price
      price
    end

    def date
      return @date unless @date.nil?
      self.request if  @data.nil?

      date = nil

      @data.each do |r|
        if r['Currency'] == @currency && r['ISIN'] == @isin && (@country.nil? || r['Country'] == @country)
          d = Date.parse(r['previousCloseDate'])
          date = d if date.nil? || date > d # take the oldest date
        end
      end
      @date = date
      date
    end

    def name
      return @name unless @name.nil?
      self.request if  @data.nil?

      @data.each do |r|
        if r['Currency'] == @currency && r['ISIN'] == @isin && (@country.nil? || r['Country'] == @country)
          @name = r['Name']
          return @name
        end
      end
      @name
    end

    private
    def request
      begin
        response = HTTParty.get(url)
      rescue URI::InvalidURIError => error
        raise Eodhd::Error.new("#{error.class}: #{error.message}")
      rescue Net::ReadTimeout => error
        raise Eodhd::Error.new("#{error.class}: #{error.message}")
      rescue Net::OpenTimeout => error
        raise Eodhd::Error.new("#{error.class}: #{error.message}")
      rescue StandardError => error
        raise Eodhd::Error.new("#{error.class}: #{error.message}")
      end

      resp = response.body
      raise Eodhd::Error.new("No response from server") if response.body.nil? || response.body.empty?

      begin
        data = JSON.parse(resp)
      rescue JSON::ParserError => error
        raise Eodhd::Error.new("#{error.class}: #{error.message}")
      rescue StandardError => error
        raise Eodhd::Error.new("#{error.class}: #{error.message}")
      end

      error_msg =
        data.class == Hash ?
          data['error'] || data['errors'] || data['Error Message'] || data['Information'] || data['Note'] || data['Info'] :
          nil

      raise Eodhd::Error.new(error_msg) unless error_msg.nil?
      @data = data
      data
    end

    def url
      "#{@base_uri}/#{@isin}?api_token=#{@key}&fmt=#{@format}"
    end

    def headers
      {
        'Content-Type': 'application/json',
        'Accept-Encoding': 'gzip, deflate, br'
      }.to_s
    end
  end
end