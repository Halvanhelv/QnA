# frozen_string_literal: true

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    FactoryBot::SyntaxRunner.class_eval do
      include ActionDispatch::TestProcess
      include RSpec::Rails::FileFixtureSupport

      def file_fixture_path
        Rails.root.join('spec', 'fixtures', 'files')
      end
    end

    FactoryBot::DefinitionProxy.class_eval do
      include ActionDispatch::TestProcess

      def file_fixture_path
        Rails.root.join('spec', 'fixtures', 'files')
      end
    end
  end
end
