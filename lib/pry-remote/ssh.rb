# frozen_string_literal: true

require 'pry-remote'
require 'net/ssh'

module PryRemote
  module SSH
    VERSION = '1.0.0'

    ##
    # Pry remote session forwarding over SSH.
    class Server
      ##
      # Initialize the services and run the Pry remote session and SSH tunnel.
      #
      #    PryRemote::SSH::Server.run('remote_host', object, options)
      def self.run(*args)
        new(*args).run
      end

      ##
      # Initialize the services.
      #
      # The only required argument is +remote_host+. By default, the +object+
      # to run the Pry remote session on is set to `nil`. The optional argument
      # +options+ hash can be used to set the +remote_user+, +local_port+, and
      # +remote_port+ for the SSH tunnel, as well as the +ssh_options+ and the
      # +pry_options+ for the Pry remote session.
      #
      #    PryRemote::SSH::Server.new('remote_host', object, options)
      def initialize(remote_host, object = nil, options = {})
        @remote_host = remote_host
        @object      = object

        @remote_user = options[:remote_user] || nil
        @local_port  = options[:local_port]  || PryRemote::DefaultPort
        @remote_port = options[:remote_port] || PryRemote::DefaultPort
        @ssh_options = options[:ssh_options] || {}
        @pry_options = options[:pry_options] || {}
      end

      ##
      # Run the Pry remote session and SSH tunnel.
      #
      # The tunnel is teared down when the Pry remote session is closed.
      def run
        pry_remote = run_pry_remote
        ssh = setup_ssh_tunnel

        run_ssh_tunnel(ssh, pry_remote)
      end

      private

      def run_pry_remote
        Thread.new do
          PryRemote::Server.run(@object, 'localhost', @local_port, @pry_options)
        end
      end

      def run_ssh_tunnel(ssh, pry_remote)
        loop do
          break unless pry_remote.alive?

          ssh.loop(1)
        end
      ensure
        ssh.close
        puts '[pry-remote] SSH Connection closed'
      end

      def setup_ssh_tunnel
        ssh = Net::SSH.start(@remote_host, @remote_user, @ssh_options)
        puts "[pry-remote] SSH Connection to #{@remote_host} established"

        ssh.forward.remote(@local_port, 'localhost', @remote_port)
        puts "[pry-remote] Forwarding port #{@local_port} to #{@remote_port}"

        ssh
      end
    end
  end
end

##
# Pry remote session forwarding over SSH.
class Object
  ##
  # Start a Pry remote session over SSH via object binding.
  #
  #    binding.remote_pry_ssh('remote_host')
  def remote_pry_ssh(remote_host, options = {})
    PryRemote::SSH::Server.run(remote_host, self, options)
  end

  alias pry_remote_ssh remote_pry_ssh
end
