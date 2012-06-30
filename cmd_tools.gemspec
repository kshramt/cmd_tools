require 'ruby_patch/object'

gem_name = File.basename(__DIR__)
require "./lib/#{gem_name}/version"

Gem::Specification.new do |s|
  s.files = `git ls-files`.split
  s.name = gem_name
  s.summary = "Command line tools."
  s.version = CmdTools::VERSION

  s.add_development_dependency 'ruby_patch', '~> 0'
  s.author = 'kshramt'
  s.description = "Command line tools. tsh: mv to ~/.myTrash. bak: bakup."
  s.executables << 'bak'
  s.executables << 'tsh'
  s.required_ruby_version = '>= 1.9.0'
end
