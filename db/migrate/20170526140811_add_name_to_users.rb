class AddNameToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :name, :string, unique: true
    User.find_each do |user|
      user.name = user.email[/[^@]*/]
      user.save!
    end
    add_index :users, :name, unique: true
  end
end
