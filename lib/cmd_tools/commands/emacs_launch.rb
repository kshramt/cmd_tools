module ::CmdTools::Commands::EmacsLaunch
  require 'ruby_patch'
  extend ::RubyPatch::AutoLoad

  # Open +files+ by +mode+ (:gui/:cui) mode.
  # Launch emacs daemon if necessary.
  # Create new frame if necessary.
  # You can edit ~/.config/cmd_tools/config.yaml to specify an emacs executable.
  # For example, if you are a Mac user who uses MacPorts, following modification will be useful.
  #   - :emacs: emacs
  #   + :emacs: /Applications/MacPorts/Emacs.app/Contents/MacOS/Emacs
  def self.run(mode, *files)
    Process.waitpid(spawn "#{::CmdTools::Config.emacs} --daemon") unless daemon_running?

    files_str = files.flatten.join(' ')
    case mode
    when :gui
      if is_gui_running?
        emacsclient_open(files_str)
      else
        spawn "emacsclient -c -n #{files_str}"
      end
    when :cui
      Process.waitpid(emacsclient_open(files_str)) # To retain a file even if a terminal, which the file was opened, have closed.
      exec "emacsclient -t #{files_str}"
    else
      raise ArgumentError, "Expected :gui or :cui, but got #{mode}."
    end
  end

  # Stop emacs daemon.
  def self.stop
    exec "emacsclient -e '(kill-emacs)'" if daemon_running?
  end

  private

  def self.daemon_running?
    system "emacsclient -e '()' > #{File::NULL} 2>&1"
  end

  def self.is_gui_running?
    ::CmdTools::Config.emacs_window_systems.include?(`emacsclient -e "(window-system)"`.strip)
  end

  def self.emacsclient_open(files_str)
    spawn "emacsclient -n #{files_str}"
  end
end
