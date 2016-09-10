class Command < ActiveRecord::Base
  belongs_to :actuator

  def url
    if value == 'on'
      "https://api.particle.io/v1/devices/0123456789abcdef/activate"
    else
      "https://api.particle.io/v1/devices/0123456789abcdef/deactivate"
    end
  end

  def payload
    if value == 'on'
      "args=#{actuator.id},1"
    else
      "args=#{actuator.id},0"
    end
  end
end
