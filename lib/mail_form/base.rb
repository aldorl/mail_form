module MailForm
    class Base
        include ActiveModel::AttributeMethods # attribute methods behavior
        include ActiveModel::Conversion
        extend ActiveModel::Naming
        include ActiveModel::Validations
        include MailForm::Validators
        extend ActiveModel::Callbacks

        attribute_method_prefix 'clear_' # clear_ is attribute prefix
        attribute_method_suffix '?' # ? is attribute suffix

        class_attribute :attribute_names
        self.attribute_names = []

        # 2) Define the callbacks. The line below will create both before_deliver
        # and after_deliver callbacks with the same semantics as in Active Record
        define_model_callbacks :deliver

        def initialize(attributes = {})
            attributes.each do |attr, value|
                self.public_send("#{attr}=", value)
            end if attributes
        end

        def self.attributes(*names)
            attr_accessor(*names)

            # Ask to define the prefix methods for the given attribute names
            define_attribute_methods(names)

            # Add new names as they are defined
            self.attribute_names += names
        end

        def persisted?
            false
        end

        def deliver
            if valid?
                run_callbacks(:deliver) do
                    MailForm::Notifier.contact(self).deliver_now
                end
            else
                false
            end
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
