class CreateList < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.string :list_name
      t.datetime :l_due_date
      t.timestamps
    end
  end
end
