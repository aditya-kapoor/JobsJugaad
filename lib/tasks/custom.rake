# # rake -T
# # # list in alphabetical order
# # #in order to group them,, we use namespace
# # #description of task
# # #truncates description to width of screen
# # #task which do not have description are not shown
# # #see specific task using their name or namespace for group
# #rake -D gives description with task line by line,no truncation of description
# # rake -P
# # #same as -T but 
# # #shows all the tasks with or without any description

# #rake -W to know location of  rake tests
# # to know all predefined rake tasks of gems 
# # find ./.rvm/gems -name "*.rake"

# #if task name is :default only running rake will run that code 

# #multiple task can have same name

# #use system("THE SYSTEM CODE HERE ") to run command prompt code 
# # eg system("clear") or system("bundle install")

# # rake [task] -n is used to dry run the code  

# # desc "first task"
# # task :first do
# #   puts `clear`
# #   puts "first!!!!";
# # end
# # desc "last task"
# # task :last => :first do
# #   puts "last ....."
# # end

#  namespace :demo do
#   desc "first task"
#   task :ppt_first do
#     puts "ppt first"
#   end
#   desc "last task"
#   task :ppt_last => [:environment,:ppt_first] do
#     emp = Employer.find(:first)
#     puts "#{emp.name}"
#     puts "ppt last"
#   end
# end
# # # # task :demo 
# # # rake -T to get ppt_first or demo or demo:ppt_first
# # # removing a desc removes them from rake -T list

# # # using parameters in rake task
# # # first param takes tasks name, other the hash of args  
# desc "to show args passing"
# task :show_args, [:number, :times] do |t,args|
#   args.with_defaults(:number => 1, :times => 1)
#   puts "T is #{t}"
#   puts "Args are #{args}"
#   puts "#{args[:number].to_i ** args[:times].to_i}"
# end

# # #INVOKE is used to call another rake task from within a rake task

# namespace :for_invoke do
#   desc "example for invoke"
#   task :example_invoke do |name|
#     n = rand(5)
#     puts "#{name}"
#     # to call without namespace
#     # Rake::Task["called_task"].invoke n
#     Rake::Task["for_invoke:called_task"].invoke
#     # Rake::Task["for_invoke:called_task"].reenable
#     # Rake::Task["for_invoke:called_task"].execute
#   end
#   desc "called from example_invoke"
#   task :called_task,[:n] => [:some_other_task] do |t,args|
#     args.with_defaults(:n => 9)
#     puts "called task with n = #{args[:n]}"
#   end

#   task :some_other_task do |t,args|
#     puts "called some other task"
#   end
# end
 
# # desc "sample"
# task :check_file => ['required'] do
#   puts "this is task 'created_file'"
# end

# namespace :copy_file do
#   desc "create file if required file exist"

# if below code run it shows a circular dependency and nothing is done
#   file "required-2" => ['required'] do
#     cp "required", "required-2"
#   end
# end
# # # checks for any change in required-2 and updated required
# # # vice-versa is not true by itself


# # namespace :copy_file do
# #   file 'required' => ['required-2'] do
# #     puts "outer "
# #     cp "required-2", "required"
# #     #
# #   end
# # end

# # file "required"  do
# #   cp "required-2", "required"
# #   puts "inner"    
# # end