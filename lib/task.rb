class Task < ActiveRecord::Base
  belongs_to :list

  # This defines Task.search
  def self.search string
    Task.find_each do |task|
      if task.task.include? string
        # something ... ?
      end
    end
  end

  def finished!
    #self.t_done = true
    #self.save!
    update t_done: true
  end

  def do_by due_date
    update due_date: due_date
  end
end  