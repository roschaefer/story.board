namespace :smaxtec_api do
  desc "get temperature"
  task :get_temperature => :environment do
    smaxtec_api_controller = SmaxtecApiController.new
    puts smaxtec_api_controller.get_temperature
  end
end
