#! /usr/bin/env ruby

require "semantic_logger"
require "dry/monads/all"
require_relative "loggable_class.rb"
require "pry"


# setup
SemanticLogger.default_level = :info
SemanticLogger.add_appender(io: $stdout, formatter: :color)
Thread.current.name = "main thread"

# working definitions

def speedy
  sleep 1
  "done quickly"
end

def pokey
  sleep 2
  "done slowly"
end


# main script

logged_speedy = -> { SemanticLogger["speedy"].measure_info "calling" do speedy end }
speedy_task = ::Dry::Monads::Task[:io] {logged_speedy.call}
logged_pokey = -> { SemanticLogger["pokey"].measure_info "calling" do pokey end }
pokey_task = ::Dry::Monads::Task[:io] {logged_pokey.call}

SemanticLogger["main"].measure_info "Calling tasks" do
  result = pokey_task.bind { |p|
    SemanticLogger["bind"].info "in bind"
    speedy_task.fmap { |s|
      SemanticLogger["fmap"].info "in fmap"
      [p, s]
    }
  }

  puts result.value!
end


