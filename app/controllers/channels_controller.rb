class ChannelsController < ApplicationController
  def show
    @response = {
      messages: [
        { text: "If you think there is good in everybody, you haven't met everybody."}
      ]
    }
    render json: @response.to_json
  end
end
