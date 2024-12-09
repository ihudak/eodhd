require 'eodhd'
require 'test_helper'

class EodhdTest < Minitest::Test
  # fixtures :all
  def setup
    super

    @data = YAML.load(File.read('test/fixtures/etf.yml'))['ie00b5bmr087'] # etf(:ie00b5bmr087)

    stub_request(:get, 'https://eodhd.com/api/search/IE00B5BMR087').
      with(query: {api_token: 'eodhd', fmt: 'json'}).
      to_return(body: @data.to_json, status: 200, headers: {content_type: 'application/json'})

    stub_request(:get, 'https://eodhd.com/api/search/IE00B5BMR087').
      with(query: {api_token: 'bad_token', fmt: 'json'}).
      to_return(body: 'Unauthenticated', status: 401, headers: {content_type: 'text/html; charset=UTF-8'})
  end

  def test_without_token
    error = assert_raises(Eodhd::Error) do
      Eodhd::Client.new(isin: 'IE00B5BMR087', currency: 'EUR').price
    end
    assert_equal 'API key is missing', error.message
  end

  def test_with_bad_token
    Eodhd.configure do |c|
      c.api_key = 'bad_token'
    end

    error = assert_raises(Eodhd::Error) do
      Eodhd::Client.new(isin: 'IE00B5BMR087', currency: 'EUR').price
    end
    assert_equal "JSON::ParserError: unexpected token at 'Unauthenticated'", error.message
  end

  def test_with_token
    Eodhd.configure do |c|
      c.api_key = 'eodhd'
    end

    p = Eodhd::Client.new(isin: 'IE00B5BMR087', currency: 'EUR').price
    d = Eodhd::Client.new(isin: 'IE00B5BMR087', currency: 'EUR').date
    n = Eodhd::Client.new(isin: 'IE00B5BMR087', currency: 'EUR').name

    assert_in_delta 610.845, p, 0.0005
    assert_equal Date.parse('2024-12-06'), d
    assert_equal 'iShares Core S&P 500 UCITS ETF USD (Acc)', n
  end
end
