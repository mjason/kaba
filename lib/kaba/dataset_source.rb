class DatasetSource
  
  attr_reader :path
  def initialize(path)
    @path = path
  end

  [:row, :schema, :test].each do |method_name|
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
      d_podfile_path = File.join(Dir.pwd, 'DPodfile.rb')
      unless File.exist?(d_podfile_path)
        FileUtils.cp(File.join(__dir__, '_DPodfile_'), d_podfile_path)
      end
      d_podfile_path
    end

    def testfile
      d_testfile_path = File.join(Dir.pwd, 'DTestfile.rb')
      unless File.exist?(d_testfile_path)
        FileUtils.cp(File.join(__dir__, '_DTestfile_'), d_testfile_path)
      end
      d_testfile_path
    end
  end


end

