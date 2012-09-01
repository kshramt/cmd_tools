require 'ruby_patch'

gem_name = File.basename(__DIR__)
require "./lib/#{gem_name}/version"

Gem::Specification.new do |s|
  s.files = `git ls-files`.split
  s.name = gem_name
  s.summary = "Command line tools."
  s.version = CmdTools::VERSION

  s.add_development_dependency 'ruby_patch', '~> 0.3'
  s.author = 'kshramt'
  s.description = <<-EOS
Command line tools. Please type

$ cmd_tools help

to see details.
  EOS
  s.executables << 'cmd_tools'
  s.post_install_message = <<-EOS

# CmdTools.
alias bak='cmd_tools backup'
alias tsh='cmd_tools trash'
alias em='cmd_tools emacs_launch --mode=gui'
alias e='cmd_tools emacs_launch --mode=cui'
alias emacs_stop=''cmd_tools emacs_stop'

  EOS
  s.required_ruby_version = '~> 1.9'
end
