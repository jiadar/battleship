module Api
  module V1
    class ApiController < ApplicationController
      include SessionsHelper
      respond_to :json
    end
  end
end
