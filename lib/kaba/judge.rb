require 'erb'

class Judge
  def initialize(input: , target: , output:)
    @input = input
    @target = target
    @output = output
  end

  def render
    ERB.new(File.read(self.class.prompt_path)).result(binding)
  end

  class << self
    def prompt_path
      @prompt_path || File.join(__dir__, 'judge.md.erb')
    end

    def set_prompt_path(path)
      @prompt_path = path
    end
  end
end