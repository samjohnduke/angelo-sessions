$:.unshift File.expand_path '../../lib', __FILE__

require 'bundler'
Bundler.require :default, :development, :test
require 'minitest/pride'
require 'minitest/autorun'
require 'angelo'
require 'angelo/minitest/helpers'
require 'angelo/sessions'

Celluloid.logger.level = ::Logger::ERROR
include Angelo::Minitest::Helpers

CK = 'ANGELO_CONCURRENCY' # concurrency key
DC = 5                    # default concurrency
CONCURRENCY = ENV.key?(CK) ? ENV[CK].to_i : DC

module Cellper

  @@stop = false
  @@testers = {}

  def define_action sym, &block
    define_method sym, &block
  end

  def remove_action sym
    remove_method sym
  end

  def unstop!
    @@stop = false
  end

  def stop!
    @@stop = true
  end

  def stop?
    @@stop
  end

  def testers; @@testers; end

end

class Reactor
  include Celluloid::IO
  extend Cellper
end

$reactor = Reactor.new

class ActorPool
  include Celluloid
  extend Cellper
end

$pool = ActorPool.pool size: CONCURRENCY
