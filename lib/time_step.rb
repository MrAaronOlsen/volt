module Volt
  class TimeStep
    attr_reader :start_time, :end_time, :dt

    def set
      @start_time = Time.now
    end

    def get_dt
      set if @start_time.nil?

      @end_time = Time.now
      @dt = (@end_time - @start_time) * 0.1
      @start_time = @end_time

      return @dt
    end
  end
end