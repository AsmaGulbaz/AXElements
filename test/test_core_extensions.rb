require 'helper'

class TestNSArrayMethodMissing < MiniTest::Unit::TestCase
  ELEMENTS = AX::DOCK.list.application_dock_items

  def test_delegates_up_if_array_is_not_composed_of_elements
    assert_raises NoMethodError do [1,2].title_ui_element end
  end

  def test_actions_are_executed
    skip 'This test is too invasive, need to find another way or add a test option'
  end

  def test_not_plural_not_predicate
    refute_empty ELEMENTS.url.compact
  end

  def test_plural_not_predicate
    refute_empty ELEMENTS.children.compact
  end

  def test_artificially_plural_not_predicate
    refute_empty ELEMENTS.urls.compact
  end

  def test_not_plural_predicate
    refute_empty ELEMENTS.application_running?.compact
  end

  # predicate names are general past tens and sound silly when
  # I try to pluralize them
  # def test_plural_predicate
  # end
  # def test_artificially_plural_predicate
  # end
end

class TestStringCoreExtensions < MiniTest::Unit::TestCase
  def test_camelize_bang_takes_snake_case_string_and_makes_it_camel_case
    assert_equal 'AMethodName', 'a_method_name'.camelize!
    assert_equal 'MethodName',  'method_name'.camelize!
    assert_equal 'Name',        'name'.camelize!
  end

  def test_camelize_bany_takes_camel_case_and_does_nothing
    assert_equal 'AMethodName', 'AMethodName'.camelize!
    assert_equal 'MethodName',  'MethodName'.camelize!
    assert_equal 'Name',        'Name'.camelize!
  end

  def test_predicate_returns_true_if_string_ends_with_a_question_mark
    assert 'test?'.predicate?
  end

  def test_predicate_returns_false_if_the_string_does_not_end_with_a_question_mark
    refute 'test'.predicate?
    refute 'tes?t'.predicate?
    refute 'te?st'.predicate?
    refute 't?est'.predicate?
    refute '?test'.predicate?
  end
end
