require File.join(File.dirname(__FILE__), '../test/test_helper')
require File.join(File.dirname(__FILE__), '../lib/argument_validator')

class MyClass
  
  include AllTweetsMustDie::ArgumentValidator
  
  def foo(args = {})
    validate_args!([:foo, :bar], args)
    "NOTHING RAISED"
  end
end


class ArgumentValidatorTest < Test::Unit::TestCase
  
  def test_with_zero_args
    assert_equal "NOTHING RAISED", MyClass.new.foo
  end
  
  def test_with_one_valid_arg
    assert_equal "NOTHING RAISED", MyClass.new.foo(:foo => 1)
  end
  
  def test_with_two_valid_args
    assert_equal "NOTHING RAISED", MyClass.new.foo(:foo => 1, :bar => 'bar')
  end
  
  def test_with_invalid_arg
    ex = assert_raises(ArgumentError) { MyClass.new.foo(:baz => 1) }
    assert_equal 'Invalid argument(s) "baz". Valid are: "bar", "foo"', ex.message
  end
  
  def test_with_two_invalid_arg
    ex = assert_raises(ArgumentError) { MyClass.new.foo(:baz => 1, :zed => 'dead') }
    assert_equal 'Invalid argument(s) "baz", "zed". Valid are: "bar", "foo"', ex.message
  end
  
  def test_with_valid_and_invalid_arg
    ex = assert_raises(ArgumentError) { MyClass.new.foo(:foo => 1, :bar => 'bar', :baz => 1) }
    assert_equal 'Invalid argument(s) "baz". Valid are: "bar", "foo"', ex.message
  end
end