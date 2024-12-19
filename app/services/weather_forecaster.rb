class WeatherForecaster
  require "net/http"
  require "uri"

  def self.call(address)
    new(address).call
  end

  def initialize(address)
    @address = address
  end

  def call
    if cache_entry.nil?
      Rails.cache.write(cache_key, fresh_response_object, expires_in: 30.minutes)

      fresh_response_object
    else
      duped_cache_entry = cache_entry
      duped_cache_entry[:status] = "cached"
      duped_cache_entry
    end
  end

  private

  def geocoded_address
    @geocoded_address ||= Geocoder.search(address).first
  end

  def uri
    URI("https://api.open-meteo.com/v1/forecast?latitude=#{geocoded_address.latitude}&longitude=#{geocoded_address.longitude}&current=temperature_2m&daily=temperature_2m_max,temperature_2m_min&temperature_unit=fahrenheit")
  end

  def response
    Net::HTTP.get_response(uri)
  end

  def response_body
    JSON.parse(response.body)
  end

  def fresh_response_object
    @fresh_response_object ||= { data: response_body, status: "fresh" }
  end

  #########
  # Cache
  #########

  def cache_key
    ["api_response", "forecast", address].join("/")
  end

  def cache_entry
    Rails.cache.read(cache_key)
  end

  attr_reader :address
end
