module LoggerHelper
  def logger
    @logger ||= Logger.new(STDOUT).tap do |logger|
      logger.formatter = proc do |severity, datetime, _progname, msg|
        color = case severity
                when 'UNKNOWN' then :gray
                when 'FATAL'   then :bg_red
                when 'ERROR'   then :red
                when 'WARN'    then :brown
                when 'INFO'    then :blue
                when 'DEBUG'   then :bg_gray
                else raise "Unknown severity #{severity}"
                end
        "#{datetime.strftime('%Y-%m-%d %H:%M:%S')} #{severity} -- #{msg}\n".send(color)
      end
    end
  end
end
