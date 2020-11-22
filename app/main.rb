#! /usr/bin/env ruby

require "semantic_logger"

SemanticLogger.default_level = :info
SemanticLogger.add_appender(io: $stdout, formatter: :color)

class LoggableClass
  include SemanticLogger::Loggable

  def self.send_log(message)
    logger.tagged(method_type: :class) do
      logger.info message
    end
  end

  def send_log(message)
    logger.tagged(method_type: :instance) do
      logger.info message
    end
  end
end

Thread.current.name = "main thread"

LoggableClass.send_log :hi
LoggableClass.new.send_log :mom
