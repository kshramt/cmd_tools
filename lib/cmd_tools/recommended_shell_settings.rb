module CmdTools
  RECOMMENDED_SHELL_SETTINGS = <<-EOS
# CmdTools
export PATH=${HOME}/.gem/ruby/1.9.1/gems/cmd_tools-#{CmdTools::VERSION}/bin/command:${PATH}
  EOS
end
