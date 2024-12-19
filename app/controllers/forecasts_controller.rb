class ForecastsController < ApplicationController
  def index
    @address = params[:address]

    if @address.present?
      # NOTE: First get the weather data from an external API
      forecast_data = WeatherForecaster.call(@address)
      # NOTE: Next we take that data and pass it to a presenter to format the data in an appealing way
      @presenter = WeatherPresenter.new(forecast_data)
    end
  end
end
