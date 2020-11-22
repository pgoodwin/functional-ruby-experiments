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
