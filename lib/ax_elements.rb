require 'active_support/core_ext/numeric'
require 'active_support/core_ext/date'
require 'active_support/core_ext/date_time'
require 'active_support/core_ext/time'

# Mix the language methods into the TopLevel
require 'accessibility/dsl'
include Accessibility::DSL

require 'accessibility/system_info'

##
# The Mac OS X dock application.
#
# @return [AX::Application]
AX::DOCK = AX::Application.new('com.apple.dock')

# Load explicitly defined elements that are optional
require 'ax/button'
require 'ax/radio_button'
require 'ax/row'
require 'ax/static_text'
require 'ax/pop_up_button'

# Misc things that we need to load
require 'ax_elements/nsarray_compat'
# require 'ax_elements/exception_workaround' # disable for now
