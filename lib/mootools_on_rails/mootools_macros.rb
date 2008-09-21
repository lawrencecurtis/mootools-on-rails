module ActionController
  # Macros are class-level calls that add pre-defined actions to the controller based on the parameters passed in.
  # Currently, they're used to bridge the JavaScript macros, like autocompletion and in-place editing, with the controller
  # backing.
  module MootoolsMacros
    module AutoComplete #:nodoc:
      def self.append_features(base) #:nodoc:
        super
        base.extend(ClassMethods)
      end

      # Example:
      #
      # no example yet, could you help?
      #
      module ClassMethods
        def auto_complete_for(object, method, options = {})
          ActionController::Base.autocompleters["#{object}_#{method}"]=options
          autocompleters
        end
        def sortable(object,options={})
          ActionController::Base.sortables["#{object}"]=options
          sortables
        end
        def autocompleters
          @@autocompleters||={}
        end
        def sortables
          @@sortables||={}
        end
      end
    end
  end
end