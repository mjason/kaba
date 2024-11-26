# frozen_string_literal: true

require 'async'
require 'faraday'
require 'colorize'
require 'tty-progressbar'
require 'async/http/faraday'
require 'openai'
require 'json/repair'
require 'yaml'

require_relative "kaba/application"
require_relative "kaba/json"

require_relative "kaba/row"
require_relative "kaba/version"
require_relative "kaba/dataset"
require_relative "kaba/dataset_source"
require_relative "kaba/prompt"
require_relative "kaba/validate"
require_relative "kaba/judge"
require_relative "kaba/test_runner"
require_relative "kaba/boot"

module Kaba
  class Error < StandardError; end
  # Your code goes here...
end
