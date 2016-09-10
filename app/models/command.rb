class Command < ActiveRecord::Base
  DEVICE_ID = '1e0033001747343339383037'

  belongs_to :actuator

  def device_id
    DEVICE_ID
  end

  def url
    url = "https://api.particle.io/v1/devices/#{device_id}"
    if value == 'on'
      url += '/activate'
    else
      url += '/deactivate'
    end
    url
  end

  def payload
    if value == 'on'
      "#{actuator.id},1"
    else
      "#{actuator.id},0"
    end
  end

  def run!
    params = {
      "access_token" => "fa56cdf00a6977ae9339e40908d72e09e1f37c29",
      "args" => payload
    }
    uri = URI.parse(url)
    Net::HTTP.post_form(uri, params)
  end
end
