require 'core/helper'


##
# AFAICT every accessibility object **MUST** have attributes, so
# there are no tests to check what happens when they do not exist.
class TestAttrsOfElement < TestCore

  def setup
    @attrs = AX.attrs_of_element(DOCK)
  end

  def test_returns_array_of_strings
    assert_instance_of String, @attrs.first
  end

  def test_make_sure_certain_attributes_are_accessible
    assert @attrs.include?(KAXRoleAttribute)
    assert @attrs.include?(KAXRoleDescriptionAttribute)
  end

  def test_other_attributes_that_the_dock_should_have
    assert @attrs.include?(KAXChildrenAttribute)
    assert @attrs.include?(KAXTitleAttribute)
  end

end


class TestAttrOfElementParsesData < TestCore

  def test_does_not_return_raw_values
    assert_kind_of AX::Element, AX.attr_of_element(FINDER, KAXMenuBarAttribute)
  end

  def test_does_not_return_raw_values_in_array
    ret = AX.attr_of_element(DOCK, KAXChildrenAttribute).first
    assert_kind_of AX::Element, ret
  end

  def test_returns_nil_for_non_existant_attributes
    assert_nil AX.attr_of_element(DOCK, 'MADEUPATTRIBUTE')
  end

  def test_logs_message_for_non_existant_attributes
    with_logging do AX.attr_of_element(DOCK, 'MADEUPATTRIBUTE') end
    assert_match /#{KAXErrorAttributeUnsupported}/, @log_output.string
  end

  def test_returns_nil_for_nil_attributes
    assert_nil AX.attr_of_element(DOCK, KAXFocusedUIElementAttribute)
  end

  def test_returns_boolean_false_for_false_attributes
    assert_equal false, AX.attr_of_element(DOCK, 'AXEnhancedUserInterface')
  end

  def test_returns_boolean_true_for_true_attributes
    ret = AX.attr_of_element(finder_dock_item, KAXIsApplicationRunningAttribute)
    assert_equal true, ret
  end

  def test_wraps_axuielementref_objects
    ret = AX.attr_of_element(FINDER, KAXMenuBarAttribute)
    assert_instance_of AX::MenuBar, ret
  end

  def test_returns_array_for_array_attributes
    ret = AX.attr_of_element(DOCK, KAXChildrenAttribute)
    assert_kind_of Array, ret
  end

  def test_returned_arrays_are_not_empty_when_they_should_have_stuff
    refute_empty AX.attr_of_element(DOCK, KAXChildrenAttribute)
  end

  def test_returns_number_for_number_attribute
    separator = children_for( LIST ).find { |item|
      attribute_for( item, KAXDescriptionAttribute ) == 'separator'
    }
    skip 'You need to have a dock separator for this test' unless separator
    assert_kind_of NSNumber, AX.attr_of_element(separator, KAXValueAttribute)
  end

  def test_returns_array_of_numbers_when_attribute_has_an_array_of_numbers
    skip 'I have no idea where to find an attribute that has this type'
  end

  def test_returns_a_cgsize_for_size_attributes
    mb = AX.attr_of_element(FINDER, KAXMenuBarAttribute)
    assert_instance_of CGSize, mb.get_attribute(:size)
  end

  def test_returns_a_cgpoint_for_point_attributes
    mb = AX.attr_of_element(FINDER, KAXMenuBarAttribute)
    assert_instance_of CGPoint, mb.get_attribute(:position)
  end

  # @todo have to go deep to find a reliable source of ranges
  def test_returns_a_cfrange_for_range_attributes
    spotlight_text_field do |field|
      range = AX.attr_of_element(field, KAXSelectedTextRangeAttribute)
      assert_instance_of CFRange, range
    end
  end

  # @todo AXAPI supports this, but I cannont find what type of element
  #       has an attribute stored as a CGRect in the documentation or
  #       in my experience
  # def test_returns_a_cgrect_for_rect_attributes
  # end

  def test_works_with_strings
    assert_kind_of NSString, AX.attr_of_element(DOCK, KAXTitleAttribute)
  end

end



class TestElementAttributeWritable < TestCore

  def test_true_for_writable_attribute
    assert AX.attr_of_element_writable?(finder_dock_item, KAXSelectedAttribute)
  end

  def test_false_for_non_writable_attribute
    refute AX.attr_of_element_writable?(DOCK, KAXTitleAttribute)
  end

  def test_false_for_non_existante_attribute
    refute AX.attr_of_element_writable?(DOCK, 'FAKE')
  end

  # # @todo this test fails because I am not getting the expected result code
  # def test_logs_errors
  #   with_logging do AX.attr_of_element_writable?(DOCK, 'OMG') end
  #   assert_match /#{KAXErrorAttributeUnsupported}/, @log_output.string
  # end

end


class TestSetAttrOfElement < TestCore

  # @todo these tests require me to go deep into a UI

  def test_set_a_text_fields_value
    spotlight_text_field do |field|
      new_value = "#{Time.now}"
      AX.set_attr_of_element( field, KAXValueAttribute, new_value )
      assert_equal new_value, attribute_for( field, KAXValueAttribute )
    end
  end

  # @todo not sure how to do this without doing a lot of work
  # def test_set_a_radio_button
  # end

end