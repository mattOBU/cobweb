class ExplorationsController < ApplicationController
    def index
    end

    def create
      render json: {buildings: [{ name: "our house", kWhm2: 128.1, kgCO2em2: 71.6, kWhocc: 3258.8, kgCO2eocc: 1820.5 }]}
    end
end
