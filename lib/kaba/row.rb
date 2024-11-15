class Row
  attr_reader :target_path, :input_file
  def initialize(file)
    @target_path = File.expand_path(file)
    @input_file = @target_path.sub(/\.target\.json$/, '.input.txt')
  end
end