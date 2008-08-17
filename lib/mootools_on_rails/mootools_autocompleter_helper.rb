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
      def autocomplete_with_associated_tag(object,method,source_object,source_method,value=nil,options={},autocomplete_options={})
        name ||= "autocomplete_for_#{object}_#{method}"
        options.merge!(:id=>name)
        autocomplete_options.merge!(:hidden_name=>"#{object}[#{method}]",
          :force_select=>true,
          :inject_choice=>INJECT_CHOICE,
          :on_show=>ON_SHOW_HIDE
          )
        javascript_tag(add_autocompleter_json("autocomplete_for_#{object}_#{method}",
                        "/autocompleter/#{source_object}/#{source_method}",
                        autocomplete_options)
                        ).concat(text_field_tag(name,value,options))
      end
      #
      # autocomplete_with_associated_field(:invoice,:customer_id,:customer,:name,{},{})
      #
      def autocomplete_with_associated_field(object,method,source_object,source_method,value=nil,options={},autocomplete_options={})
        name ||= "autocomplete_for_#{object}_#{method}"
        options.merge!(:id=>name)
        
        autocomplete_options.merge!(:hidden_name=>"#{object}[#{method}]",
          :force_select=>true,
          :inject_choice=>INJECT_CHOICE,
          :on_show=>ON_SHOW_HIDE
          )
        javascript_tag(add_autocompleter_json("autocomplete_for_#{object}_#{method}",
                        "/autocompleter/#{source_object}/#{source_method}",
                        autocomplete_options)
                        ).concat(text_field_tag(name,value,options))
      end
      #
      # autocomplete_with_associated_field(:invoice,:customer_id,:customer,:name,{},{})
      #
      def autocomplete_multiple_with_associated_tag(object,method,source_object,source_method,value=nil,options={},autocomplete_options={})
        name ||= "autocomplete_for_#{object}_#{method}"
        options.merge!(:id=>name)
        autocomplete_options.merge!(:hidden_name=>"#{object}[#{method}]",
          :multiple=>true,
          :inject_choice=>INJECT_CHOICE
          )
        javascript_tag(add_autocompleter_json("autocomplete_for_#{object}_#{method}",
                        "/autocompleter/#{source_object}/#{source_method}",
                        autocomplete_options)
                        ).concat(text_field_tag(name,value,options))
      end
    end
  end
end