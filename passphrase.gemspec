lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "passphrase/version"

Gem::Specification.new do |spec|
  spec.name        = "passphrase"
  spec.version     = Passphrase::Version::STRING
  spec.license     = "MIT"
  spec.summary     = "Generate passphrases using the Diceware Method"
  spec.description = <<-EOF
    Passphrase is a library and command-line tool for generating passphrases
    using the Diceware Method. The method selects words from a predefined
    database of more-or-less recognizable words, making the resulting
    passphrases easier to remember and type. And because the words are selected
    randomly, the result is more secure.
  EOF
  spec.author      = "Edmund Sumbar"
  spec.email       = "esumbar@gmail.com"
  spec.homepage    = "https://github.com/esumbar/passphrase"

  spec.cert_chain  = ['certs/esumbar.pem']
  spec.signing_key = File.expand_path("~/.gem/gem-private_key.pem") if $0 =~ /gem\z/

  spec.files       = Dir["{bin,lib,spec}/**/*"] + %w(README.md CHANGELOG.md LICENSE)
  spec.executables = [ "passphrase" ]

  spec.required_ruby_version = '>=1.9'
  spec.add_runtime_dependency 'sqlite3', '~> 1.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'yard', '~> 0.8'
  spec.add_development_dependency 'redcarpet', '~> 3.2'
  spec.requirements << "SQLite 3 system library"
end
