module ::CmdTools::Config
  require 'yaml'
  require 'fileutils'
  require 'ruby_patch'
  extend ::RubyPatch::AutoLoad

  CONFIG_DIR = File.join(ENV['HOME'], '.config/cmd_tools')
  CONFIG_FILE = File.join(CONFIG_DIR, 'config.yaml')
  CONFIG_DEFAULT = {
    emacs: ENV['ALTERNATE_EDITOR'] || 'emacs',
  }

  # (Re)load config file.
  def self.load
    @config = if File.size?(CONFIG_FILE) and File.readable?(CONFIG_FILE)
                CONFIG_DEFAULT.merge(YAML.load_file(CONFIG_FILE))
              else
                FileUtils.mkdir_p(CONFIG_DIR)
                open(CONFIG_FILE, 'w'){|io|
                  io.write(CONFIG_DEFAULT.to_yaml)
                  io.flush
                }
                CONFIG_DEFAULT
              end

    self
  end

  def self.emacs
    @config[:emacs]
  end

  self.load
end
