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
Command line tools:
  tsh: mv files to ~/.myTrash.
  bak: backup files.
  emacs_daemon: launch `emacs --daemon'.
  EOS
  s.executables << 'bak'
  s.executables << 'tsh'
  s.executables << 'emacs_launcher_gui'
  s.executables << 'emacs_launcher_cui'
  s.post_install_message = <<-EOS

# CmdTools.
alias em='emacs_launcher_gui'
alias e='emacs_launcher_cui'

  EOS
  s.required_ruby_version = '~> 1.9'
end
