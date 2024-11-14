## 用于将所有数据进行验证
class Validate
  def initialize(schema:, type_name:)
    @schema = schema
    @type_name = type_name
  end

  def run(input)
    request_body = {
      schema: @schema,
      typeName: @type_name,
      jsonData: input
    }

    Application.connection.post('/validate', request_body)
  end

  # 读取某个文件然后运行
  def run_file(file)
    input = JSON.parse File.read(File.expand_path file)
    ValidateReponse.new run(input), file: file
  end

  # 读取某个文件夹下的然后运行，运行有结果了 block 会被调用
  # limit 用于限制读取的文件数量, 为 nil 时读取所有文件
  def run_files(dir, limit: nil, &block)
    files = Dir[File.join(File.expand_path(dir), '*.target.json')]
    files = files.first(limit) if limit

    progressbar = TTY::ProgressBar.new("Validate: [:bar] :percent :current/:total", total: files.size)

    Async do
      files.each do |file|
        Async do
          input = JSON.parse(File.read(file))
          response = ValidateReponse.new run(input), file: file

          if block
            block.call(response, progressbar)
          else
            unless response.success?
              progressbar.log "validate failed".colorize(:red)
              response.to_s.split("\n").each do |line|
                progressbar.log line
              end
              progressbar.log "\n"
            end
          end
          progressbar.advance
        end
      end
    end.wait
  end

  class ValidateReponse
    attr_reader :response, :body, :file

    def initialize(response, file: nil)
      @response = response
      @body = JSON.parse(response.body)
      @file = file
    end

    def success?
      @response.status == 200 && @body["success"]
    end

    def message
      @body["message"]
    end

    def data
      @body["data"]
    end

    def to_s
      s = "#{'success:'.colorize(:bold_blue)} #{success? ? 'true'.colorize(:green) : 'false'.colorize(:red)}"
      s += "\n#{'file:'.colorize(:bold_blue)} #{file&.to_s&.colorize(:yellow)}"
      s += "\n#{'message:'.colorize(:bold_blue)} #{message&.colorize(:yellow)}" unless success?
      s += "\n\n"
    end
  end

end