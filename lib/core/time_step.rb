module Volt
  class TimeStep
    attr_reader :start_time, :end_time

    def initialize
      @start_time = Time.now
    end

    def get_dt
      @end_time = Time.now
      dt = (@end_time - @start_time)
      @start_time = @end_time

      return dt
    end
  end
end