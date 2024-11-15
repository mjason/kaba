require 'erb'

class TestRunner
  def initialize(path, schema:, type_name:, prompt:, validate:)

    @test_files = Dir.glob(File.join(File.expand_path(path), '*.target.json'))
    @lines = []
    @schema = schema
    @type_name = type_name
    @prompt = prompt || Prompt.new(@schema, @type_name)
    @validate = validate || Validate.new(schema: @schema, type_name: @type_name)

    @type_right_total = 0
    @score_total = 0

  end

  def _each(limit: nil)
    @test_files.first(limit || @test_files.size).each do |file|
      yield(Row.new(file), self)
    end
  end

  def scan(
    limit: nil, 
    model: 'spark-general-4.0', 
    judge_model: 'spark-general-4.0',  
    judge_temperature: 0.1, 
    temperature: 0.1
    )

    progressbar = TTY::ProgressBar.new(
      "Test: [:bar] :percent :current/:total",
       total: @test_files.first(limit || @test_files.size).size
    )

    progressbar.start

    Async do
      _each(limit: limit) do |row|
        Async do |task|
          input = @prompt.render(File.read row.input_file)

          target = <<~Markdown
          ```json
          #{JSON.pretty_generate(JSON.parse(File.read(row.target_path)))}
          ```
          Markdown
          output = Application.llm_client.chat(
            parameters: {
              model: model,
              messages: [ { role: 'user', content: input } ],
              temperature: temperature,
            }
          ).dig("choices", 0, "message", "content")
          

          output_json = JSON.parse_llm_response output

          type_check_response = JSON.parse @validate.run(output_json).body
          @type_right_total += 1 if type_check_response["success"]
          
          judge_input = Judge.new(input: input, output: output, target: target).render
          judge_response = Application.llm_client.chat(
            parameters: {
              model: judge_model,
              messages: [ { role: 'user', content: judge_input } ],
              temperature: judge_temperature,
            }
          ).dig("choices", 0, "message", "content")

          judge_json = JSON.parse_llm_response judge_response
          @score_total += judge_json["score"].to_i

          @lines << {
            row: row,
            input: input,
            output: output,
            output_json: output_json,
            type_check_response: type_check_response,
            target: target,
            judge_response: judge_response,
            judge_json: judge_json,
          }

          progressbar.advance
        end
      end
    end.wait
  end

  def save(file_path)
    File.open(File.expand_path(file_path), 'w') do |file|
      file.puts ERB.new(File.read(self.class.report_template_path)).result(binding)
    end
  end


  class << self
    def report_template_path
      @report_template_path || File.join(__dir__, 'report.html.erb')
    end

    def report_template_path=(path)
      @report_template_path = path
    end
  end

end