# frozen_string_literal: true

require_relative "lib/kaba/version"

Gem::Specification.new do |spec|
  spec.name = "kaba"
  spec.version = Kaba::VERSION
  spec.authors = ["MJ"]
  spec.email = ["tywf91@gmail.com"]

  spec.summary = "用来做数据集的工具"
  spec.description = "用来做数据集的工具"
  spec.homepage = "https://github.com/mjason/kaba.git"
  spec.required_ruby_version = ">= 3.3.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/mjason/kaba.git"
  spec.metadata["changelog_uri"] = "https://github.com/mjason/kaba.git"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "async", "~> 2.20"
  spec.add_dependency "faraday", "~> 2.12"
  spec.add_dependency "async-http-faraday", "~> 0.19.0"
  spec.add_dependency "colorize", "~> 1.1"
  spec.add_dependency "tty-progressbar", "~> 0.18.3"
  spec.add_dependency "dotenv", "~> 3.1"
  spec.add_dependency "ruby-openai", "~> 7.3"
  spec.add_dependency "json-repair", "~> 0.2.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
