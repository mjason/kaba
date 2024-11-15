module JSON

  def self.parse_llm_response(response_text)
    start_index = response_text.index('{')
    end_index = response_text.rindex('}')

    unless start_index && end_index && end_index > start_index
      raise "Invalid JSON response: #{response_text}"
    end

    json_text = response_text[start_index..end_index]
    JSON.parse JSON.repair(json_text)
  end
  
end