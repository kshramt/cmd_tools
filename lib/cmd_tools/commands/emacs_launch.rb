module ::CmdTools::Commands::EmacsLaunch
  require 'ruby_patch'
  extend ::RubyPatch::AutoLoad

  EMACSCLIENT_OPEN = lambda{|files| spawn "emacsclient -n #{files}"}

  # Open +files+ by +mode+ (:gui/:cui) mode.
  # Launch emacs daemon if necessary.
  # Create new frame if necessary.
  # You can edit ~/.config/cmd_tools/config.yaml to specify an emacs executable.
  # For example, if you are a Mac user who uses MacPorts, following modification will be useful.
  #   - :emacs: emacs
  #   + :emacs: /Applications/MacPorts/Emacs.app/Contents/MacOS/Emacs
  def self.run(mode, *files)
    Process.waitpid(spawn "#{::CmdTools::Config.emacs} --daemon") unless daemon_running?

    files = files.flatten.join(' ')
    case mode
    when :gui
      if is_gui_running?
        EMACSCLIENT_OPEN[files]
      else
        spawn "emacsclient -c -n #{files}"
      end
    when :cui
      Process.waitpid(EMACSCLIENT_OPEN[files]) # To retain a file even if a terminal, which the file was opened, have closed.
      exec "emacsclient -t #{files}"
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
    %w[x ns].include?(`emacsclient -e "(window-system)"`.strip)
  end
end
