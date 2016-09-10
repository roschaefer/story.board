class Command < ActiveRecord::Base
  FUNCTIONS =  [:activate, :deactivate]
  enum function: FUNCTIONS
  enum status: {pending: 0, executed: 1, errored: 2, dropped: 3}

  DEVICE_ID = '1e0033001747343339383037'
  ACCESS_TOKEN = "fa56cdf00a6977ae9339e40908d72e09e1f37c29"

  belongs_to :actuator

  def device_id
    DEVICE_ID
  end

  def access_token
    ACCESS_TOKEN
  end

  def url
    "https://api.particle.io/v1/devices/#{device_id}/#{function}"
  end

  def argument
    "#{actuator.port}"
  end

  def run!
    params = {
      "access_token" => access_token,
      "args" => argument
    }
    uri = URI.parse(url)
    response = Net::HTTP.post_form(uri, params)
    if response.kind_of? Net::HTTPSuccess
      self.status = 'executed'
    else
      self.status = 'errored'
    end
    save!
  end
end
