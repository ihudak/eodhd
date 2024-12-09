EODHD Gem
=============================================

[EODHD API](https://eodhd.com/) is an API provider for retrieving Stock and ETF prices in JSON format.  

EODHD Gem uses the EODHD API to retrieve daily prices of stocks and ETFs by their ISIN.   

## How to use

1. Create your account at [EODHD](https://eodhd.com/) to get api token  
2. To install EODHD: `gem install eodhd`  
3. To use it in your application:
   ``` ruby
   requre 'Eodhd'
   
   Eodhd.configure do |config|
     config.api_key = '<api-key obtained on step #1>'
   end
   ```    


## How to test

To test the Gem create eodhd.yml file inside the folder /spec with inside a line

``` ruby
key: [YOUR KEY]
```
## Support

* Bug reports, suggestions are welcome. Feel free to create issues and/or pull requests.  

