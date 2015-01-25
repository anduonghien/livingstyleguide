require 'test_helper'

class DocumentTestCase < Minitest::Test

  def setup
    @class = Class.new(LivingStyleGuide::Document)
  end

  def assert_render_equals(input, expected_output, options = {})
    @doc = @class.new{ input.unindent }
    @doc.type = options[:type] || :markdown
    @doc.template = options[:template] || 'plain'
    output = @doc.render
    assert_equal(normalize(expected_output), normalize(output))
  end

  def assert_render_match(input, expected_output, options = {})
    @doc = @class.new{ input.gsub(/\n\n/, "\n      \n").unindent }
    @doc.type = options[:type] || :markdown
    @doc.template = options[:template] || 'plain'
    output = @doc.render
    assert_match(/#{normalize(expected_output)}/, normalize(output))
  end

end
