class Prompt
  def initialize(schema, type_name)
    @schema = schema
    @type_name = type_name
  end

  def json_model(schema, input, pretty_model: false)
    pretty_model = pretty_model ? '使用 2 个空格缩进' : '用最紧凑的方式'
    <<~MARKDOWN
    你是一个服务，将用户请求翻译为类型为"#{@type_name}"的JSON对象，遵循以下TypeScript定义：
    ```
    #{schema}
    ```
    以下是用户请求：
    """
    #{input}
    """
    请将上述用户请求翻译为一个JSON对象，#{pretty_model}，且不包含值为 undefined 的属性。
    MARKDOWN
  end

  def yml_model(schema, input)
    <<~MARKDOWN
    你是一个服务，将用户请求翻译为类型为"#{@type_name}"的YAML对象，遵循以下TypeScript定义：
    ```
    #{schema}
    ```
    以下是用户请求：
    """
    #{input}
    """
    请将上述用户请求翻译为一个YAML对象，用最紧凑的方式，且不包含值为 undefined 的属性。
    MARKDOWN
  end

  def clear_export
    @schema.gsub(/export\s+default\s+/, '').gsub(/export\s+/, '')
  end

  def render(input, export: false, format: 'json', pretty_model: false)
    schema = export ? clear_export : @schema
    if format == 'json'
      return json_model(schema, input, pretty_model: pretty_model)
    elsif format == 'yml'
      return yml_model(schema, input)
    end
  end

  class << self
    def file(schema_path, type_name)
      self.new File.read(File.expand_path schema_path), type_name
    end
  end
end