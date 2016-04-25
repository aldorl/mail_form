module MailForm
    class Base
        include ActiveModel::AttributeMethods # attribute methods behavior
        attribute_method_prefix 'clear_' # clear_ is attribute prefix

        def self.attributes(*names)
            attr_accessor(*names)

            # Ask to define the prefix methods for the given attribute names
            define_attribute_methods(names)
        end

        protected

            # Since "clear_" prefix was declared, it expects to have a
            # "clear_attribute" method defined, which receives an attribute
            # name and implements the clearing logic.
            def clear_attribute(attr)
                send("#{attr}=", nil)
            end
    end
end