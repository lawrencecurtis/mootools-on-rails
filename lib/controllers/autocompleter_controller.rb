class AutocompleterController < ActionController::Base
  def index
      object = params[:object]
      method = params[:method]
      if ActionController::Base.autocompleters.key?("#{object}_#{method}")
        
        options = ActionController::Base.autocompleters["#{object}_#{method}"]
        if options[:conditions]
          if options[:conditions].kind_of?(Proc)
             options[:conditions] = options[:conditions].call(params)
          end
        end
        find_options = { 
          :conditions => [ "LOWER(#{method}) LIKE ?", '%' + params[:value].downcase + '%' ], 
          :order => "#{method} ASC",
          :limit => 10 }.merge!(options)
    
        @items = object.to_s.camelize.constantize.find(:all, find_options)

        render :json => @items.collect{|i| [i.send(method.to_sym),"#{i.id}"]}
      else
        render :text=>"no autocompleter. Check if added to the correct controller the sentence :autocomplete_for :object,:method"
      end
  end
end