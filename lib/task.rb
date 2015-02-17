class Task < ActiveRecord::Base
  belongs_to :list

  def finished!
    #self.t_done = true
    #self.save!
    update t_done: true
  end
end  