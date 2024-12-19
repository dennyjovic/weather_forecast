require 'rails_helper'

describe WeatherForecaster do
  describe ".call" do
    let(:address) { "123 Main St." }

    before do
      allow(Geocoder).to receive(:search)
                     .and_return([OpenStruct.new(latitude: "1", longitude: "1")])

      allow(Net::HTTP).to receive(:get_response)
                      .and_return(double(body: { foo: 'bar' }.to_json, content_type: 'application/json'))
    end

    context "when the address has not been cached" do
      it "stores the response in cache and returns the response" do
        result = described_class.call(address)

        expect(result[:data]).to eq({ 'foo' => 'bar' })
        expect(result[:status]).to eq 'fresh'
      end
    end

    context "when the address has been cached" do
      before do
        cache_key = ["api_response", "forecast", address].join("/")
        cache_value = {
          data: {
            "foo" => "bar"
          },
          status: "fresh"
        }
        allow(Rails.cache).to receive(:read).with(cache_key).and_return(cache_value)
      end

      it "returns the stored cache with a status of 'cached'" do
        result = described_class.call(address)

        expect(result[:data]).to eq({ 'foo' => 'bar' })
        expect(result[:status]).to eq 'cached'
      end
    end
  end
end
