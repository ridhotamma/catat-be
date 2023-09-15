class Api::V1::SearchLocationsController < ApplicationController
      def search
        address = params[:address]

        locations = Geocoder.search("#{address}", geocoding_service: :google, limit: 10)

        if locations != []
          render json: { message: "location found", data: locations }
        else
          render json: { message: "location not found", data: [] }
        end
      end
end
