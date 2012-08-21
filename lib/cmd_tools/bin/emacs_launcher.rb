module CmdTools
  module Bin
    module EmacsLauncher
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
        system "#{::CmdTools::Config.emacs} --daemon" unless self.daemon_running?

        files = files.flatten.join(' ')
        case mode
        when :gui
          if self.number_of_frames <= 1 # emacs daemon has one (invisible) frame.
            system "emacsclient -c -n #{files}"
          else
            system "emacsclient -n #{files}"
          end
        when :cui
          system "emacsclient -t #{files}"
        else
          raise ArgumentError, "Unknown mode: #{mode}"
        end
      end

      def self.daemon_running?
        system "emacsclient -e '()' > /dev/null 2>&1"
      end

      def self.number_of_frames
        `emacsclient -e "(length (visible-frame-list))"`.to_i
      end
    end
  end
end
