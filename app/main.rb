#! /usr/bin/env ruby

require "semantic_logger"

SemanticLogger.default_level = :info
SemanticLogger.add_appender(io: $stdout, level: :info, formatter: :color)

class LoggableClass
  include SemanticLogger::Loggable

  def self.send_log
    logger.info "class method log"
  end

  def send_log
    logger.info "instance method log"
  end
end

logger = SemanticLogger["main"]
logger.info "begin"

LoggableClass.send_log
LoggableClass.new.send_log
