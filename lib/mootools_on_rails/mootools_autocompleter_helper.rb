module ActionView
  module Helpers
    module MootoolsAutocompleterHelper
      INJECT_CHOICE = <<-JS
      function(choice){
        var el = new Element('li')
        .set('html',this.markQueryValue(choice[0]))
        .adopt(new Element('span', {'class': 'additional_info'}).set('html',this.markQueryValue(choice[1])));
        el.inputValue = choice[0];
        el.inputKey = choice[1];
        this.addChoiceEvents(el).inject(this.choices);
      }
      JS
      ON_SHOW_HIDE= <<-JS
      function(){ this.hidden.value = '';
      }
      JS
      
      #
      # autocomplete_with_associated_field(:invoice,:customer_id,:customer,:name,{},{})
      #
      # Is a drop down replacement, but with autocomplete, this mean you will get
      # a field object[method_id] with the associated id of the autocompleted text.
      # associated_object (for belongs_to)
      def autocomplete_with_associated_tag(object,method,associated_object,associated_method,value=nil,options={},autocomplete_options={})
        autocomplete_options.merge!(:hidden_name=>"#{object}[#{method}]",
          :force_select=>true,
          :inject_choice=>INJECT_CHOICE,
          :on_show=>ON_SHOW_HIDE
          )
          autocomplete_any(object,method,associated_object,associated_method,autocomplete_options,value,options)
      end
      #
      # autocomplete_multiple_with_associated_field(:invoice,:customer_id,:customer,:name,{},{})
      # alias for has_many ;-)
      #
      def autocomplete_multiple_with_associated_tag(object,method,associated_object,associated_method,value=nil,options={},autocomplete_options={})
        autocomplete_options.merge!(:hidden_name=>"#{object}[#{method}][]",
          :multiple=>true,
          :inject_choice=>INJECT_CHOICE
          )
        autocomplete_any(object,method,associated_object,associated_method,autocomplete_options,value,options)
      end
      private
      def autocomplete_any(object,method,associated_object,associated_method,autocomplete_options,value,options)
        field_name ||= "autocomplete_for_#{object}_#{method}"
        options.merge!(:id=>field_name)
        javascript_tag(add_autocompleter_json("autocomplete_for_#{object}_#{method}",
                        "/autocompleter/#{associated_object}/#{associated_method}",
                        autocomplete_options)
                        ).concat(text_field_tag(field_name,value,options))
      end
    end
  end
end