class InitializeDefaultContexts < ActiveRecord::Migration[5.0]
  class PublishingContext < ActiveRecord::Base; end

  def up
    PublishingContext.create!(name: "milk_quantity")
    PublishingContext.create!(name: "milk_quality")
    PublishingContext.create!(name: "movement")
    PublishingContext.create!(name: "temperature")
    PublishingContext.create!(name: "intake")
    PublishingContext.create!(name: "birth")
    PublishingContext.create!(name: "calf")
    PublishingContext.create!(name: "noise")
    PublishingContext.create!(name: "health")
  end

  def down
    PublishingContext.destroy_all
  end
end
