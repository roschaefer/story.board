class ChannelsController < ApplicationController
  def show
    @response = {
      messages: [
        { text: "If you think there is good in everybody, you haven't met everybody."}
      ]
    }
    respond_to do |format|
      format.json {
        render json: @response.to_json
      }
    end
  end
end
