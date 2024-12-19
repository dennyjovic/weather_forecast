class WeatherPresenter
  def initialize(forecast_data)
    @forecast_data = forecast_data
  end

  def current_temperature
    find_temperature(weather_data.dig('current', 'temperature_2m'))
  end

  def current_max_temperature
    find_temperature(max_temperatures[0])
  end

  def current_min_temperature
    find_temperature(min_temperatures[0])
  end

  def weekly_forecast
    dates.map.with_index do |date, idx|
      # NOTE: Skip the 1st element in the forecast because its today's min/max (which we already have)
      # NOTE: With more time this could be accomplished with more certainty by dealing with timezones and comparing
      # the current date, in a formatted way to compare with the "date" provided here.
      next if idx == 0

      # NOTE: Return an open struct so that on the front end its a cleaner and consistent look with dot notation
      OpenStruct.new(
        date: date,
        max_temperature: find_temperature(max_temperatures[idx]),
        min_temperature: find_temperature(min_temperatures[idx]),
      )
    end.compact
  end

  def cached?
    forecast_data.dig(:status) == "cached"
  end

  private

  attr_reader :forecast_data

  def find_temperature(value)
    if value.blank?
      "Unknown"
    else
      "#{value}° F"
    end
  end

  def weather_data
    forecast_data.dig(:data) || {}
  end

  def max_temperatures
    @max_temperatures ||= weather_data.dig('daily', 'temperature_2m_max') || []
  end

  def min_temperatures
    @min_temperatures ||= weather_data.dig('daily', 'temperature_2m_min') || []
  end

  def dates
    @dates ||= weather_data.dig('daily', 'time') || []
  end
end
