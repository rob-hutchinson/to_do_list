class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :task
      t.datetime :t_due_date
      t.boolean :t_done, :default => false

      t.timestamps
    end
  end
end
