class DatasetSource
  
  attr_reader :path
  def initialize(path)
    @path = path
  end

  [:row, :schema].each do |method_name|
    define_method(method_name) do
      self.class.new(File.join(@path, method_name.to_s))
    end
  end

  def read
    File.read @path
  end

  def to_s
    @path
  end

  def to_path
    @path
  end

  def join(name)
    self.class.new File.join(@path, name)
  end

  class << self
    def podfile
      d_podfile_path = File.join(Dir.pwd, 'DPodfile')
      unless File.exist?(d_podfile_path)
        FileUtils.cp(File.join(__dir__, '_DPodfile_'), d_podfile_path)
      end
    end
  end

end

