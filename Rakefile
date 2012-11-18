require 'rake/testtask'
require 'ruby_patch'

::Rake::TestTask.new do |t|
  t.libs = ['lib', 'test'].map{|dir| File.join(__DIR__, dir)}
  t.pattern = "test/**/test_*.rb"
end
