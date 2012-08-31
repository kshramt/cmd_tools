module ::CmdTools::Command::Backup
      require 'fileutils'
      require 'find'
      require 'ruby_patch'
      extend ::RubyPatch::AutoLoad

      BAK_DIR_HEAD = "bak_since_"
      BAK_DIR_REG = /(\A|\/)#{BAK_DIR_HEAD}\d{12}\z/
      BAK_PREFIX = 'bak.'

      # Back up files and directories to <tt>bak_dir</tt>.
      # @param [Array<String>] files Files and directories to be backed up.
      def self.run(*files)
        time_stamp = Time.now.ymdhms
        bak_dir = get_bak_dir(time_stamp)
        nested_bak_dir_reg = /\A#{bak_dir}\/.*#{BAK_DIR_HEAD}\d{12}\z/
        FileUtils.mkdir_p(bak_dir)
        (files.flatten.map{|f| f.chomp('/')} - ['.', '..', bak_dir])\
          .select{|f| File.exist?(f)}\
          .each{|f|
          dest = get_dest(bak_dir, f, time_stamp)
          begin
            FileUtils.cp_r(f, dest)
          rescue
            warn "WARN: Failed to back up #{f}."
          end

          delete_nested_bak_dir(dest, nested_bak_dir_reg) if(File.directory?(dest))
        }
      end

      private

      def self.get_bak_dir(time_stamp)
        Dir.foreach('.')\
          .select{|f| File.directory?(f)}\
          .select{|f| f =~ BAK_DIR_REG}\
          .first\
        or BAK_DIR_HEAD + time_stamp
      end

      def self.get_dest(bak_dir, file, time_stamp)
        ext = File.extname(file)
        File.join(bak_dir, [BAK_PREFIX, file, '.', time_stamp, ext].join)
      end

      def self.delete_nested_bak_dir(dest, nested_bak_dir_reg)
        Find.find(dest){|f| # I did not used #select method chain style to use Find.prune.
          next unless File.directory?(f)
          next unless f =~ nested_bak_dir_reg

          $stdout.puts "Delete #{f}? [y/N]"
          if $stdin.gets.strip =~ /\Ay/i
            $stdout.puts "Deleting: #{f}"
            FileUtils.rm_rf(f)
            Find.prune
          end
        }
      end
end
