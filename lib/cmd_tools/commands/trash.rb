module ::CmdTools::Commands::Trash
  require 'fileutils'
  require 'ruby_patch'
  extend ::RubyPatch::AutoLoad

  TRASH_DIR = File.join(ENV['HOME'], '.myTrash')

  # Move files and directories into <tt>TRASH_DIR</tt>.
  # @param [Array<String>] files Files and directories to be moved into <tt>TRASH_DIR</tt>.
  def self.run(*files)
    FileUtils.mkdir_p(TRASH_DIR)
    time = Time.now.ymdhms
    prefix = File.join(TRASH_DIR, time) + '.'
    (files.flatten - ['.', '..'])\
      .select{|f| File.exist?(f)}\
      .each{|f|
      begin
        FileUtils.mv(f, prefix + File.basename(f))
      rescue
        warn "WARN: Failed to discard #{f}."
      end
    }
  end
end
