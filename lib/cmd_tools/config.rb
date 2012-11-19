module ::CmdTools::Config
  require 'yaml'
  require 'fileutils'
  require 'ruby_patch'
  extend ::RubyPatch::AutoLoad

  CONFIG_DIR = File.join(ENV['HOME'], '.config/cmd_tools')
  CONFIG_FILE = File.join(CONFIG_DIR, 'config.yaml')
  MACPORTS_EMACS = '/Applications/MacPorts/Emacs.app/Contents/MacOS/Emacs'
  CONFIG_DEFAULT = {
    'emacs' => if `uname`.chomp == "Darwin" && File.executable?(MACPORTS_EMACS)
                 MACPORTS_EMACS
               else
                 ENV['ALTERNATE_EDITOR'] || 'emacs'
               end,
    'emacs_window_systems' => %w[x ns mac],
  }

  @config = nil

  # (Re)load config file.
  def self.load
    need_dump = false
    @config = if File.readable?(CONFIG_FILE) && File.size(CONFIG_FILE) > 0
                config_from_file = YAML.load_file(CONFIG_FILE)
                config = CONFIG_DEFAULT.merge(config_from_file)
                need_dump = config_from_file.size != CONFIG_DEFAULT.size

                config
              else
                need_dump = true

                CONFIG_DEFAULT
              end

    if need_dump
      FileUtils.mkdir_p(CONFIG_DIR)
      open(CONFIG_FILE, 'w'){|io|
        io.write(@config.to_yaml)
        io.flush
      }
    end

    @config.each{|name, val|
      var = "@#{name}"
      instance_variable_set(var, val)
      eval <<-EOS
        def self.#{name}
          #{var}
        end
      EOS
    }

    self
  end

  self.load
end
