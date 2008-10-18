class SortableController < ActionController::Base
  def index
      object = params[:object]
      actual_order = params[:order].split(",").collect { |item| (item.split("_")).last}
      if ActionController::Base.sortables.key?("#{object}")
        options = {:collection=>:all}
        options.merge!(ActionController::Base.sortables["#{object}"])
        
        klass = object.to_s.camelize.constantize
        
        all_items = klass.send(options[:collection]).collect { |i| "#{i.id}" }

        logger.info "new_order: #{actual_order}"
        logger.info "all_items: #{all_items}"

        actual_order.each_index do |item|
          logger.info "set position #{item+1} for #{actual_order[item]}"
          node = klass.find(actual_order[item]).insert_at(item+1)
        end
        
        render :text=>"sorted"
      else
        render :text=>"no sortable. Check if added to the correct controller the sentence :sortable_for :object"
      end
  end
end