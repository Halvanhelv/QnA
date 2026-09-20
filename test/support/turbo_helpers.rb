# frozen_string_literal: true

module TurboHelpers
  TURBO_STREAM = { 'Accept' => 'text/vnd.turbo-stream.html, text/html, application/xhtml+xml' }.freeze

  def turbo_headers
    TURBO_STREAM
  end

  def assert_turbo_stream(action:, target:)
    assert_select "turbo-stream[action='#{action}'][target='#{target}']"
  end
end

module ActionDispatch
  class IntegrationTest
    include TurboHelpers
  end
end
