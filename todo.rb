require "pry"
require "./db/setup"
require "./lib/all"
require 'faker'
require 'colorize'
require 'date'

puts "#{Faker::Hacker.say_something_smart}".colorize(:light_red)

def add task, list
  a = List.find_or_create_by! list_name: list
  Task.create! task: task, list_id: a.id 
end

def due task, due_date
  a = Task.find(task)
  a.t_due_date = Date.parse(due_date)
  a.save!
end

def done id
  a = Task.find(id)
  a.t_done = true
  a.save!
end

def print 
  Task.order(list_id: :asc).where(t_done: false).each do |x|
    puts "#{x.task.capitalize} from #{List.find(x.list_id).list_name.upcase} is INCOMPLETE! It is due: #{x.t_due_date}.".colorize(:red)
  end
end

def print_list list_name
  puts "Printing list: #{list_name.upcase}".colorize(:light_blue)
  tasks = Task.order(list_id: :asc).where(list_id: List.find_by(list_name: list_name).id).each do |x|
    puts "#{x.task.capitalize} from #{List.find(x.list_id).list_name.upcase} is INCOMPLETE! It is due: #{x.t_due_date}.".colorize(:red)
  end
end

def print_all
  Task.order(list_id: :asc).each do |x|
    if x.t_done == false
      puts "#{x.task.capitalize} from #{List.find(x.list_id).list_name.upcase} is INCOMPLETE! It is due: #{x.t_due_date}.".colorize(:red)
    else
      puts "#{x.task.capitalize} from #{List.find(x.list_id).list_name.upcase} is COMPLETE!".colorize(:green)
    end
  end
end

command = ARGV.shift
case command
when "add"
  # Add task entry and list entry
  list = ARGV.first.downcase
  task = ARGV[1].downcase

  add task, list
when "due"
  # Tags tasks with due dates
  task = ARGV.first
  due_date = ARGV[1]

  due task, due_date
when "done"
  # Marks a given task as completed
  id = ARGV.first

  done id
when "list"
  # Various ways to list your to-dos
  if ARGV.empty?
    print
  elsif ARGV.first == "all"
    print_all
  else
    list_name = ARGV.first.downcase
    print_list list_name
  end
end