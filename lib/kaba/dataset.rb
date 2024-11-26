class Dataset
  attr_reader :lines

  def initialize(data_dir, prompt)
    @data_files = Dir.glob(File.join(File.expand_path(data_dir), '*.target.json'))
    @lines = []
    @prompt = prompt

    @formats_size = 0
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
    @lines.size == @formats_size
  end

  def scan(limit: nil, formats: ['json', 'yml', 'json_pretty'])
    @formats_size = 0
    progressbar = TTY::ProgressBar.new(
      "Dataset: [:bar] :percent :current/:total", 
      total: @data_files.first(limit || @data_files.size).size)
    Async do
      _each(limit: limit) do |row, ds|
        Async do
          # 格式化输出
          if formats.include?('json_pretty')
            pretty_target = <<~Markdown
            ```json
            #{JSON.pretty_generate(JSON.parse(File.read(row.target_path)))}
            ```
            Markdown

            instruction = @prompt.render(File.read(row.input_file), pretty_model: true)
            ds.add({ instruction: instruction, output: pretty_target })

            instruction = @prompt.render(File.read(row.input_file), export: true, pretty_model: true)
            ds.add({ instruction: instruction, output: pretty_target })

            @formats_size += 2
          end

          # 未格式化输出
          if formats.include?('json')
            json_target = <<~Markdown
            ```json
            #{JSON.generate(JSON.parse(File.read(row.target_path)))}
            ```
            Markdown
            instruction = @prompt.render(File.read(row.input_file), pretty_model: false)
            ds.add({ instruction: instruction, output: json_target })

            instruction = @prompt.render(File.read(row.input_file), export: true, pretty_model: false)
            ds.add({ instruction: instruction, output: json_target })

            @formats_size += 2
          end

          # YAML 格式输出
          if formats.include?('yml')
            yaml_target = <<~Markdown
            ```yaml
            #{YAML.dump(JSON.parse(File.read(row.target_path))).sub(/^---\s*\n/, '')}
            ```
            Markdown
            instruction = @prompt.render(File.read(row.input_file), format: 'yml')
            ds.add({ instruction: instruction, output: yaml_target })

            @formats_size += 1
          end

          progressbar.advance
        end
      end
    end.wait
  end

end