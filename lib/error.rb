module Error
  class UndefinedMethod < StandardError
    def initialize(object, method)
      @object = object
      @method = method

      super(msg)
    end

    def msg
      "Please define method '##{@method}' for #{@object.inspect}"
    end
  end
end
