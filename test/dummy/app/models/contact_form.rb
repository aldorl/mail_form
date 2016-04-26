class ContactForm < MailForm::Base
    attributes :name, :email, :message, :nickname

    def headers
        { to: "recipient@example.com", from: self.email }
    end
end
