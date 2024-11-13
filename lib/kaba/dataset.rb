class Dataset
  attr_reader :lines

  def initialize(data_dir, prompt)
    @data_files = Dir.glob(File.join(File.expand_path(data_dir), '*.target.json'))
    @lines = []
    @prompt = prompt
  end

  ## 实现一个 each 方法，可以让用户通过 block 的方式遍历数据集，提供一个 add 方法，可以将数据添加到数据集中
  def _each(limit: nil)
    @data_files.first(limit || @data_files.size).each do |file|
      yield(Row.new(file), self)
    end
  end

  def each(limit: nil, &block)
    puts "Waring: each is very dangerous".colorize(:red)
    _each(limit: limit, &block)
  end

  def add(data)
    @lines << data
  end

  def save(file_path)
    File.open(File.expand_path(file_path), 'w') do |file|
      @lines.each do |line|
        file.puts(line.to_json)
      end
    end
  end

  def validate
    @lines.size == (@data_files.size * 2)
  end

  def scan(limit: nil)
    progressbar = TTY::ProgressBar.new("Dataset: [:bar] :percent :current/:total", total: @data_files.size)
    Async do
      _each(limit: limit) do |row, ds|
        Async do
          instruction = @prompt.render(File.read row.input_file)
          target = <<~Markdown
          ```json
          #{JSON.pretty_generate(JSON.parse(File.read(row.target_path)))}
          ```
          Markdown
          ds.add({ instruction: instruction, output: target })

          instruction = @prompt.render(File.read(row.input_file), export: true)
          ds.add({ instruction: instruction, output: target })

          progressbar.advance
        end
      end
    end.wait
  end

end

class Row
  attr_reader :target_path, :input_file
  def initialize(file)
    @target_path = File.expand_path(file)
    @input_file = @target_path.sub(/\.target\.json$/, '.input.txt')
  end
end