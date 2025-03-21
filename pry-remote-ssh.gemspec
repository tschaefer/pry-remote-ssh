# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'pry-remote/ssh'

Gem::Specification.new do |spec|
  spec.name        = 'pry-remote-ssh'
  spec.version     = PryRemote::SSH::VERSION
  spec.platform    = Gem::Platform::RUBY
  spec.authors     = ['Tobias Schäfer']
  spec.email       = ['github@blackox.org']

  spec.summary     = 'Connect to Pry remotely via SSH forwarding'
  spec.description = <<~DESC
    #{spec.summary}
  DESC
  spec.homepage = 'https://github.com/tschaefer/pry-remote-ssh'
  spec.license  = 'MIT'

  spec.files                 = Dir['lib/**/*']
  spec.require_paths         = ['lib']
  spec.required_ruby_version = '>= 3.1'

  spec.post_install_message = 'All your Pry connection are belong to us!'

  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.metadata['source_code_uri']       = 'https://github.com/tschaefer/pry-remote-ssh'
  spec.metadata['bug_tracker_uri']       = 'https://github.com/tschaefer/pry-remote-ssh/issues'

  spec.add_dependency 'net-ssh', '>=7.2', '<7.4'
  spec.add_dependency 'pry-remote', '>=0.1', '<0.3'
end
