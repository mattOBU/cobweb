class Explore::CommunityGroupsController < ApplicationController
    def index
    end

    def create
      render json: {buildings: [{ name: "our house", :annual => [{year: 2013, kWhm2: 128.1, kgCO2em2: 71.6, kWhocc: 3258.8, kgCO2eocc: 1820.5, mains: 115658, producedUsed: 41961, producedExported: 9167}] }]}
    end
end
