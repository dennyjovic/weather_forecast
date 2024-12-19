require 'rails_helper'

describe WeatherPresenter do
  describe ".current_temperature" do
    context "when the 'temperature_2m' key is present" do
      it "returns the value formatted with degrees and Farenheit" do
        input = {
          data: {
            'current' => {
              'temperature_2m' => 70
            }
          }
        }

        result = described_class.new(input)

        expect(result.current_temperature).to eq "70° F"
      end
    end

    context "when the 'temperature_2m' key is not present" do
      it "returns 'Unknown'" do
        input = {
          data: {
            'current' => {
              'foo' => 'bar'
            }
          }
        }

        result = described_class.new(input)

        expect(result.current_temperature).to eq "Unknown"
      end
    end

    context "when the 'data' is null" do
      it "returns 'Unknown" do
        input = {}

        result = described_class.new(input)

        expect(result.current_temperature).to eq "Unknown"
      end
    end
  end

  describe ".current_max_temperature" do
    context "when the 'temperature_2m_max' key is present" do
      it "returns the value formatted with degrees and Farenheit" do
        input = {
          data: {
            'daily' => {
              'temperature_2m_max' => [80]
            }
          }
        }

        result = described_class.new(input)

        expect(result.current_max_temperature).to eq "80° F"
      end
    end

    context "when the 'temperature_2m_max' key is not present" do
      it "returns 'Unknown'" do
        input = {
          data: {
            'daily' => {
              'foo' => ['bar']
            }
          }
        }

        result = described_class.new(input)

        expect(result.current_max_temperature).to eq "Unknown"
      end
    end

    context "when the 'data' is null" do
      it "returns 'Unknown" do
        input = {}

        result = described_class.new(input)

        expect(result.current_max_temperature).to eq "Unknown"
      end
    end
  end

  describe ".current_min_temperature" do
    context "when the 'temperature_2m_min' key is present" do
      it "returns the value formatted with degrees and Farenheit" do
        input = {
          data: {
            'daily' => {
              'temperature_2m_min' => [60]
            }
          }
        }

        result = described_class.new(input)

        expect(result.current_min_temperature).to eq "60° F"
      end
    end

    context "when the 'temperature_2m_min' key is not present" do
      it "returns 'Unknown'" do
        input = {
          data: {
            'daily' => {
              'foo' => ['bar']
            }
          }
        }

        result = described_class.new(input)

        expect(result.current_min_temperature).to eq "Unknown"
      end
    end

    context "when the 'data' is null" do
      it "returns 'Unknown" do
        input = {}

        result = described_class.new(input)

        expect(result.current_min_temperature).to eq "Unknown"
      end
    end
  end

  describe ".weekly_forecast" do
    context "when there is more than 1 element in the collection" do
      it "returns a collection of objects and skips the 1st element" do
        input = {
          data: {
            'daily' => {
              'time' => ['2024-12-18','2024-12-19'],
              'temperature_2m_max' => [100,80],
              'temperature_2m_min' => [10,60],
            }
          }
        }

        result = described_class.new(input)

        expect(result.weekly_forecast.length).to eq 1
        expect(result.weekly_forecast.first.date).to eq '2024-12-19'
        expect(result.weekly_forecast.first.max_temperature).to eq "80° F"
        expect(result.weekly_forecast.first.min_temperature).to eq "60° F"
      end
    end

    context "when there is only 1 element in the collection" do
      it "returns an empty collection" do
        input = {
          data: {
            'daily' => {
              'time' => ['2024-12-18'],
              'temperature_2m_max' => [100],
              'temperature_2m_min' => [10],
            }
          }
        }

        result = described_class.new(input)

        expect(result.weekly_forecast.length).to eq 0
      end
    end

    context "when one key is missing" do
      it "returns a collection of objects and skips the 1st element" do
        input = {
          data: {
            'daily' => {
              'time' => ['2024-12-18','2024-12-19'],
              'temperature_2m_min' => [10,60],
            }
          }
        }

        result = described_class.new(input)

        expect(result.weekly_forecast.length).to eq 1
        expect(result.weekly_forecast.first.date).to eq '2024-12-19'
        expect(result.weekly_forecast.first.max_temperature).to eq "Unknown"
        expect(result.weekly_forecast.first.min_temperature).to eq "60° F"
      end
    end

    context "when the 'data' is null" do
      it "returns 'Unknown" do
        input = {}

        result = described_class.new(input)

        expect(result.weekly_forecast.length).to eq 0
      end
    end
  end

  describe ".cached?" do
    context "when the 'status' is not 'cached' but 'fresh'" do
      it "returns false" do
        input = {
          status: "fresh"
        }

        result = described_class.new(input)

        expect(result.cached?).to eq false
      end
    end

    context "when the 'status' is not 'cached' but 'foo'" do
      it "returns false" do
        input = {
          status: "foo"
        }

        result = described_class.new(input)

        expect(result.cached?).to eq false
      end
    end

    context "when the 'status' is 'cached'" do
      it "returns false" do
        input = {
          status: "cached"
        }

        result = described_class.new(input)

        expect(result.cached?).to eq true
      end
    end
  end
end
