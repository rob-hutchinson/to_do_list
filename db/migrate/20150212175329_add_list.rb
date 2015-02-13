class AddList < ActiveRecord::Migration
  def change
    change_table :tasks do |t|
      t.integer :list_id
    end
  end
end
