module ThreadingHelpers
  extend self

  def background(name='Default', &block)

    Thread.new do
      begin

        yield

      rescue => ex
        Rails.logger.error("Background Thread #{name} failed with #{ex}")
        Rails.logger.error(ex.backtrace.join("\n"))
      ensure
        ActiveRecord::Base.connection.close
      end
    end

  end

end