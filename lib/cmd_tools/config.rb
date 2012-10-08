module ::CmdTools::Config
  require 'yaml'
  require 'fileutils'
  require 'ruby_patch'
  extend ::RubyPatch::AutoLoad

  CONFIG_DIR = File.join(ENV['HOME'], '.config/cmd_tools')
  CONFIG_FILE = File.join(CONFIG_DIR, 'config.yaml')
  CONFIG_DEFAULT = {
    'emacs' => ENV['ALTERNATE_EDITOR'] || 'emacs',
  }

  # (Re)load config file.
  def self.load
    need_dump = false
    @config = if File.readable?(CONFIG_FILE)
                config = CONFIG_DEFAULT.merge(YAML.load_file(CONFIG_FILE))
                need_dump = config.size > CONFIG_DEFAULT.size

                config
              else
                need_dump = true

                CONFIG_DEFAULT
              end

    if need_dump
      FileUtils.mkdir_p(CONFIG_DIR)
      open(CONFIG_FILE, 'w').write(@config.to_yaml)
    end

    self
  end

  def self.emacs
    @config['emacs']
  end

  self.load
end
