require File.dirname(__FILE__)+"/tests_init"
$:.unshift File.dirname(__FILE__)+"/../examples"

require 'test/unit'
require 'xml/xxpath_methods'

require 'xml/mapping'

# unit tests for some code in ../examples. Most of that code is
# included in ../README and tested when regenerating the README, but
# some things are better done outside.
class ExamplesTest < Test::Unit::TestCase

  def test_time_node
    require 'time_node'
    require 'order_signature_enhanced'

    s = Signature.load_from_file File.dirname(__FILE__)+"/../examples/order_signature_enhanced.xml"
    assert_equal Time.local(2005,2,13), s.signed_on
    assert_equal 'Doe John', s.signature.txt
    assert_equal 'John Doe', s.signature.previous

    s.signed_on = Time.local(2006,6,15)
    s.signature.test_name = "test"
    xml2 = s.save_to_xml

    assert_equal "15", xml2.first_xpath("signed-on/day").text
    assert_equal "6", xml2.first_xpath("signed-on/month").text
    assert_equal "2006", xml2.first_xpath("signed-on/year").text
    assert_equal 'Doe John', xml2.first_xpath('user-sign').text
    assert_equal 'John Doe', xml2.first_xpath('user-sign').attributes['previous']
    assert_equal 'test', xml2.first_xpath('user-sign').attributes['test_name']
    assert_equal nil, xml2.first_xpath('user-sign').attributes['txt']
  end

end
