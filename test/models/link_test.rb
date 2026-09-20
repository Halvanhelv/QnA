# frozen_string_literal: true

require 'test_helper'

class LinkTest < ActiveSupport::TestCase
  test 'requires name and url' do
    link = Link.new(linkable: questions(:rails))
    assert_not link.valid?
    assert_includes link.errors.attribute_names, :name
    assert_includes link.errors.attribute_names, :url
  end

  test 'rejects malformed urls' do
    assert_not Link.new(linkable: questions(:rails), name: 'x', url: 'not a url').valid?
  end

  test 'gist? detects gist urls' do
    assert Link.new(url: 'https://gist.github.com/user/abc').gist?
    assert_not Link.new(url: 'https://google.com').gist?
  end

  test 'gist_files returns an empty hash when GitHub is unavailable' do
    link = Link.new(url: 'https://gist.github.com/user/abc')
    link.define_singleton_method(:get_gist) { raise Octokit::Error }
    assert_equal({}, link.gist_files)
  end
end
