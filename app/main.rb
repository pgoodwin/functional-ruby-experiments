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

def with_measure_logging(name, &block)
  -> {
    SemanticLogger[name].measure_info("calling", &block)
  }
end

def create_measured_task(name, &block)
  ::Dry::Monads::Task[:io, &with_measure_logging(name, &block)]
end

# main script

speedy_task = create_measured_task("speedy") { speedy }
pokey_task = create_measured_task("pokey") { pokey }

SemanticLogger["main"].measure_info "Calling tasks" do
  result = pokey_task.bind { |p|
    SemanticLogger["bind"].info "in bind"
    speedy_task.fmap { |s|
      SemanticLogger["fmap"].info "in fmap"
      [p, s]
    }
  }

  puts result.value!.inspect
end


