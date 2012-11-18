require 'thor'

class ::CmdTools::Application < Thor
  require 'ruby_patch'
  extend ::RubyPatch::AutoLoad

  desc "min_max < FILE", "Return the minmum and maximum value of each column."
  method_option :min_max_separator, default: "\t", aliases: "-m"
  method_option :field_separator, default: "\t", aliases: "-f"
  def min_max()
    puts ::CmdTools::Commands::MinMax.run($stdin.read, options[:min_max_separator])\
      .join(options[:field_separator])
  end

  desc "backup FILE1 FILE2 ...", "Backup files and directories."
  def backup(*files)
    puts ::CmdTools::Commands::Backup.run(*files).join("\t")
  end

  desc "trash FILE1 FILE2 ...", "Move files and directories to ~/.myTrash"
  def trash(*files)
    puts ::CmdTools::Commands::Trash.run(*files).join("\t")
  end

  desc "emacs_launch FILE1 FILE2 ...", "Launch emacs in MODE mode."
  long_desc <<-EOS
Launch emacs in (G|C)UI mode.

1. If emacs daemon is not running, start a new daemon.

2. If GUI mode and no frame exist, create a new frame.

3. Open files by emacsclient in (G|C)UI mode.
  EOS
  method_option :mode, type: :string, required: true, desc: "MODE should be 'gui' or 'cui'."
  def emacs_launch(*files)
    mode = options['mode'].to_sym
    ::CmdTools::Commands::EmacsLaunch.run(mode, *files)
  end

  desc "emacs_stop", "Stop emacs daemon."
  def emacs_stop
    ::CmdTools::Commands::EmacsLaunch.stop
  end
end
