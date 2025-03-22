# Connect to Pry remotely via SSH forwarding

This is an extension for the [Pry remote
gem](https://github.com/Mon-Ouie/pry-remote) that allows to forward a Pry
remote session over a SSH tunnel to a remote machine.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pry-remote-ssh'
```

Or install via gem:

```bash
gem install pry-remote-ssh
```

## Usage

Here's a program starting pry-remote-ssh:

```ruby
require 'pry-remote/ssh'

class Foo
  def initialize(x, y)
    binding.remote_pry_ssh 'remote-host'
  end
end

Foo.new 10, 20
```

Running it will prompt you with a message telling you Pry is waiting for a
program to connect itself to it:

```bash
[pry-remote] Waiting for client on druby://localhost:9876
[pry-remote] SSH Connection to remote-host established
[pry-remote] Forwarding port 9876 to 9876
```

You can then connect yourself using pry-remote:

```bash
pry-remote
```

```ruby
From: example.rb:5 Foo#initialize:

    4: def initialize(x, y)
 => 5:   binding.remote_pry_ssh 'remote-host'
    6: end

[1] [/#<Foo:0x00007f339ed02590>] >> self
=> #<Foo:0x00007f339ed02590>
[2] [/#<Foo:0x00007f339ed02590>] >> ls -l
y = 20
x = 10
```
