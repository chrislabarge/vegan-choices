# frozen_string_literal: true
# Ingredient
class Ingredient
  EXPECTED_ATTR_TYPES = { and_or: 'Ingredient instance with #context',
                          nested: 'Array of Ingredients',
                          context: 'String',
                          description: 'String' }.freeze

  attr_accessor :name, :and_or, :nested, :context, :description

  def initialize(name,
                 and_or: nil,
                 nested: nil,
                 context: nil,
                 description: nil)

    self.name = name
    self.and_or = and_or if and_or
    self.nested = nested if nested
    self.context = context if context
    self.description = description if description
  end

  # Overrides the setter attribute methods in order to validate values
  EXPECTED_ATTR_TYPES.keys.each do |attr|
    method_name = attr.to_s + '='

    define_method(method_name) do |value|
      validation_method = attr.to_s + '_type?'
      validated = send(validation_method, value)
      instance_variable_name = "@#{attr}"

      return instance_variable_set(instance_variable_name, value) if validated

      raise Error::AttributeType.new(self,
                                     attr,
                                     EXPECTED_ATTR_TYPES[attr],
                                     value)
    end
  end

  private

  def nested_type?(value)
    (value.is_a? Array) && (value.map(&:class).uniq.count == 1)
  end

  def and_or_type?(value)
    (value.is_a? Ingredient) && !value.context.nil?
  end

  def description_type?(value)
    value.is_a? String
  end

  def context_type?(value)
    value.is_a? String
  end
end
