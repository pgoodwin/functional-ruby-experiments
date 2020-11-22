#! /usr/bin/env ruby

require "semantic_logger"

SemanticLogger.default_level = :info
SemanticLogger.add_appender(io: $stdout, level: :info, formatter: :color)

class LoggableClass
  include SemanticLogger::Loggable

  def self.send_log(message)
    logger.tagged(method_type: :class)
    logger.info message
  end

  def send_log(message)
    logger.tagged(method_type: :instance)
    logger.info message
  end
end

LoggableClass.send_log :hi
LoggableClass.new.send_log :mom
