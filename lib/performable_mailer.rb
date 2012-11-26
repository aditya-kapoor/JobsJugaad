module Delayed
  class PerformableMailer < PerformableMethod
    def perform
      # raise "args: #{args.inspect}"
      object.send(method_name, *args).deliver
    end
  end
end

