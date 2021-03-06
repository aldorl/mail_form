require 'test_helper'
require 'fixtures/sample_mail'

class ComplianceTest < ActiveSupport::TestCase
    include ActiveModel::Lint::Tests

    def setup
        @model = SampleMail.new
    end

    test "model_name exposes singular and human name" do
        assert_equal "sample_mail", @model.class.model_name.singular
        assert_equal "Sample mail", @model.class.model_name.human
    end

    test "model_name.human uses I18n" do
        begin
            I18n.available_locales = [:en, :es]

            I18n.locale = :es
            I18n.backend.store_translations :es,
                activemodel: { models: { sample_mail: "Mi Correo Muestra" } }
            assert_equal "Mi Correo Muestra", @model.class.model_name.human

            I18n.locale = :en
            I18n.backend.store_translations :en,
                activemodel: { models: { sample_mail: "My Sample Mail" } }
            assert_equal "My Sample Mail", @model.class.model_name.human
        ensure
            I18n.reload!
        end
    end
end
