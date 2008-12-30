require 'rubygems'
require 'rake/rdoctask'

require 'merb-core'
require 'merb-core/tasks/merb'

include FileUtils

# Load the basic runtime dependencies; this will include 
# any plugins and therefore plugin rake tasks.
init_env = ENV['MERB_ENV'] || 'development'
Merb.load_dependencies(:environment => init_env)
     
# Get Merb plugins and dependencies
Merb::Plugins.rakefiles.each { |r| require r } 

# Load any app level custom rakefile extensions from tasks
tasks_path = File.join(File.dirname(__FILE__), "tasks")
rake_files = Dir["#{tasks_path}/*.rake"]
rake_files.each{|rake_file| load rake_file }

desc "Start runner environment"
task :merb_env do
  Merb.start_environment(:environment => init_env, :adapter => 'runner')
end

require 'spec/rake/spectask'
require 'merb-core/test/tasks/spectasks'
desc 'Default: run spec examples'
task :default => 'spec'

namespace :app do
  task :restart do
    sh 'touch tmp/restart.txt'
  end

	task :doc do
		sh 'rdoc -aUSN -w 2 -W http://github.com/alfanick/irc-logger/tree/master/%s --op doc/all --charset utf-8 --exclude autotest --exclude doc --exclude merb --exclude var --exclude log --exclude tmp -w 2 --title irc-logger'
	end
end

##############################################################################
# ADD YOUR CUSTOM TASKS IN /lib/tasks
# NAME YOUR RAKE FILES file_name.rake
##############################################################################
