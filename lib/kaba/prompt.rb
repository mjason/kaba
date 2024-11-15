class Prompt
  def initialize(schema, type_name)
    @schema = schema
    @type_name = type_name
  end

  def clear_export
    @schema.gsub(/export\s+default\s+/, '').gsub(/export\s+/, '')
  end

  def render(input, export: false)
    schema = export ? clear_export : @schema
    request_body = {
      schema: schema,
      typeName: @type_name,
      input: input
    }
    resp = Application.connection.post('/prompt', request_body).body
  end

  class << self
    def file(schema_path, type_name)
      self.new File.read(File.expand_path schema_path), type_name
    end
  end
end