# frozen_string_literal: true

require 'async'
require 'faraday'
require 'colorize'
require 'tty-progressbar'
require 'async/http/faraday'

require_relative "kaba/version"
require_relative "kaba/dataset"
require_relative "kaba/dataset_source"
require_relative "kaba/prompt"
require_relative "kaba/validate"

module Kaba
  class Error < StandardError; end
  # Your code goes here...
end
