class AutocompleterController < ActionController::Base
  def index
      object = params[:object]
      method = params[:method]
      if ActionController::Base.autocompleters.key?("#{object}_#{method}")
        options = {}
        find_options = { 
          :conditions => [ "LOWER(#{method}) LIKE ?", '%' + params[:value].downcase + '%' ], 
          :order => "#{method} ASC",
          :limit => 10 }.merge!(options)
    
        @items = object.to_s.camelize.constantize.find(:all, find_options)

        render :json => @items.collect{|i| i[method]}
      else
        render :text=>"no autocompleter"
      end
  end
end