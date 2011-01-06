module ActiveModel
  module Validations
    class ValvatValidator < ::ActiveModel::EachValidator
      DEFAULT_MESSAGE = "is not a valid european vat number."
      
      def validate_each(record, attribute, value)
        is_valid = Valvat::Syntax.validate(value)
        
        if is_valid && options[:lookup]
          is_valid = Valvat::Lookup.validate(value)
          is_valid.nil? && is_valid = (options[:lookup] != :fail_if_down)
        end

        record.errors.add(attribute, :invalid_vat, :message => options[:message] || DEFAULT_MESSAGE) unless is_valid
      end
    end
  end
end