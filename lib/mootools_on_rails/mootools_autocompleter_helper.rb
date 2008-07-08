module ActionView
  module Helpers
    module MootoolsAutocompleterHelper
      def autocomplete_field_tag(object,method,name=nil,value=nil,options={},mootools_options={})
        name ||= "#{object}_#{method}"
        options.merge!(:id=>"autocomplete_for_#{object}_#{method}")
        javascript_tag(add_autocompleter_json("autocomplete_for_#{object}_#{method}",
                        "/autocompleter/#{object}/#{method}",
                        mootools_options)
                        ).concat(text_field_tag(name,value,options))
      end
    end
  end
end