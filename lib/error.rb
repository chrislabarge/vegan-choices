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

  class AttributeType < StandardError
    def initialize(object, attribute, expected, received)
      @object = object
      @attribute = attribute
      @expected = expected
      @received = received

      super(msg)
    end

    def msg
      "'##{@attribute}' attribute must be #{@expected} for #{@object.inspect}. Received #{@received.inspect}"
    end
  end
end
