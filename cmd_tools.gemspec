require 'ruby_patch'

gem_name = File.basename(__DIR__)
require "./lib/#{gem_name}/version"
require "./lib/#{gem_name}/recommended_shell_settings"

Gem::Specification.new do |s|
  s.files = `git ls-files`.split
  s.name = gem_name
  s.summary = "Command line tools."
  s.version = CmdTools::VERSION

  s.add_runtime_dependency 'ruby_patch', '~> 2.0'
  s.add_runtime_dependency 'thor', '~> 0.16'
  s.author = 'kshramt'
  s.description = <<-EOS
Command line tools. Please type

$ cmd_tools help

to see details.
  EOS
  s.executables << 'cmd_tools'
  s.post_install_message = "\n#{::CmdTools::RECOMMENDED_SHELL_SETTINGS}\n"
  s.required_ruby_version = '>= 1.9'
end
