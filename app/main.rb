#! /usr/bin/env ruby

require "semantic_logger"
require_relative 'loggable_class.rb'

SemanticLogger.default_level = :info
SemanticLogger.add_appender(io: $stdout, formatter: :color)
Thread.current.name = "main thread"

LoggableClass.send_log :hi
LoggableClass.new.send_log :mom
