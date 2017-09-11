class UpdateTimeframes < ActiveRecord::Migration[5.0]
  def change
    TextComponent.transaction do
      TextComponent.where(from_hour: 18, to_hour: 23).update_all(to_hour: 0)
      TextComponent.where(from_hour: 23, to_hour: 6).update_all(from_hour: 0)
    end
  end
end
