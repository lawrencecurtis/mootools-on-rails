require File.dirname(__FILE__) + '/test_helper'

class MootoolsHelperTest < Test::Unit::TestCase
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::JavaScriptHelper
  include ActionView::Helpers::MootoolsHelper
  include ActionView::Helpers::MootoolsAutocompleterHelper

  def test_autocomplete_with_associated_tag
    actual = autocomplete_with_associated_tag :invoice,:customer_id,:customer,:name,"Hello!"
    mootools_options_expected ="{forceSelect:true, hiddenName:\"invoice[customer_id]\", injectChoice:#{INJECT_CHOICE}, onShow:#{ON_SHOW_HIDE}}"
    expected = %(<script type="text/javascript">\n//<![CDATA[\nwindow.addEvent('domready', function() {new Autocompleter.Ajax.Json('autocomplete_for_invoice_customer_id', '/autocompleter/customer/name', #{mootools_options_expected});});\n//]]>\n</script><input id="autocomplete_for_invoice_customer_id" name="autocomplete_for_invoice_customer_id" type="text" value="Hello!" />)
    assert_dom_equal expected, actual
  end
  def test_autocomplete_multiple_with_associated_tag
    actual = autocomplete_multiple_with_associated_tag :invoice,:customer_id,:customer,:name,"Hello!"
    mootools_options_expected ="{hiddenName:\"invoice[customer_id]\", injectChoice:#{INJECT_CHOICE}, multiple:true}"
    expected = %(<script type="text/javascript">\n//<![CDATA[\nwindow.addEvent('domready', function() {new Autocompleter.Ajax.Json('autocomplete_for_invoice_customer_id', '/autocompleter/customer/name', #{mootools_options_expected});});\n//]]>\n</script><input id="autocomplete_for_invoice_customer_id" name="autocomplete_for_invoice_customer_id" type="text" value="Hello!" />)
    assert_dom_equal expected, actual
  end

end