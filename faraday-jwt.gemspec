# frozen_string_literal: true

require_relative 'lib/faraday/jwt/version'

Gem::Specification.new do |spec|
  spec.name = 'faraday-jwt'
  spec.version = Faraday::Jwt::VERSION
  spec.authors = ['nov']
  spec.email = ['nov@matake.jp']

  spec.summary = 'Faraday Middleware for JWT Request & Response'
  spec.description = 'Faraday Middleware for JWT Request & Response'
  spec.homepage = 'https://github.com/nov/faraday-jwt'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.6.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = File.join(spec.homepage, 'blob/main/CHANGELOG.md')

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '~> 2.0'
  spec.add_dependency 'json-jwt', '~> 1.16'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'simplecov'
end
