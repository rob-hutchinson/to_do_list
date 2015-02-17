require "pry"
require "./db/setup"
require "./lib/all"
require "colorize"
require "thor"

class Todo < Thor
  desc "add TASK LIST", "Adds [TASK] to [LIST]"
  def add task, list
    addition task, list
  end

  desc "due TASK DUE_DATE", "Marks task with [TASK] ID with a [DUE DATE]"
  def due task, due_date
    do_by task, due_date
  end

  desc "done ID", "Marks the task with the given [ID] as done"
  def done id
    finished id
  end

  desc "next", "Returns a random uncompleted task"
  def next
    rando
  end

  desc "search STRING", "Searches tasks for [STRING] and returns appropriate tasks"
  def search string
    john_wayne string
  end

  desc "list [ALL/LIST]", "Prints unfinished tasks or optionally tasks from [LIST] or [ALL] tasks"
  def list arg = nil
    print arg
  end
end

def addition task, list
  a = List.find_or_create_by! list_name: list
  Task.create! task: task, list_id: a.id 
end

def do_by task, due_date
  a = Task.find(task)
  a.t_due_date = Date.parse(due_date)
  a.save!
end

def finished id
  a = Task.find(id)
  a.t_done = true
  a.save!
end

def rando
  x = Task.where.not(t_due_date: nil, t_done: true).order("RANDOM()").first
  unless x == nil
    done_or_not(x)
  else
    x = Task.where(t_done: false).order("RANDOM()").first
    done_or_not(x)
  end
end

def john_wayne string
  Task.find_each do |y|
    if y.task.include?(string)
      done_or_not(y)
    end
  end
end

def print arg=nil
  if arg == nil
    Task.order(list_id: :asc).where(t_done: false).each do |x|
      done_or_not(x)
    end
  elsif arg == "all" 
    print_all
  else
    print_list arg
  end
end

def print_list list_name
  Task.order(list_id: :asc).where(list_id: List.find_by(list_name: list_name).id).each do |x|
    done_or_not(x)
  end
end

def print_all
  Task.order(list_id: :asc).each do |x|
    done_or_not(x)
  end
end

def done_or_not task
  if task.t_done == false
    puts "#{task.id}) #{task.task.capitalize} from list #{List.find(task.list_id).list_name.upcase} is INCOMPLETE! It is due: #{task.t_due_date}.".colorize(:red)
  else
    puts "#{task.id}) #{task.task.capitalize} from list #{List.find(task.list_id).list_name.upcase} is COMPLETE!".colorize(:green)
  end
end

Todo.start(ARGV)
