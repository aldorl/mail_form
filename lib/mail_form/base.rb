module MailForm
    class Base
        include ActiveModel::AttributeMethods # attribute methods behavior
        include ActiveModel::Conversion
        extend ActiveModel::Naming
        include ActiveModel::Validations

        attribute_method_prefix 'clear_' # clear_ is attribute prefix
        attribute_method_suffix '?' # ? is attribute suffix

        def self.attributes(*names)
            attr_accessor(*names)

            # Ask to define the prefix methods for the given attribute names
            define_attribute_methods(names)
        end

        def persisted?
            false
        end

        protected

            # Since "clear_" prefix was declared, it expects to have a
            # "clear_attribute" method defined, which receives an attribute
            # name and implements the clearing logic.
            def clear_attribute(attr)
                send("#{attr}=", nil)
            end

            # Implement the logic required by the '?' suffix
            def attribute?(attr)
                send(attr).present?
            end
    end
end
