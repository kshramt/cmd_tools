module ::CmdTools::Command::MinMax
  require 'ruby_patch'
  extend ::RubyPatch::AutoLoad

  def self.run(str, min_max_separator = "\t")
    str.split("\n")\
      .map{|l| l.split.map{|field| field.to_f}}\
      .transpose\
      .map(&:minmax)\
      .map{|min_max| min_max.join(min_max_separator)}
  end
end
