module ::CmdTools::Command::EmacsLaunch
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
      if number_of_frames() <= 1 # emacs daemon has one (invisible) frame.
        spawn "emacsclient -c -n #{files}"
      else
        EMACSCLIENT_OPEN[files]
      end
    when :cui
      Process.waitpid(EMACSCLIENT_OPEN[files])
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

  def self.number_of_frames
    `emacsclient -e "(length (visible-frame-list))"`.to_i
  end
end
