module MootoolsOnRails
  class << self
    # Add MootoolsOnRails.routes in RAILS_ROOT/config/routes.rb
    def routes
      ActionController::Routing::Routes.add_route "/behaviours/*page_path", :controller => "unobtrusive_javascript", :action => "generate"
      ActionController::Routing::Routes.add_route "/autocompleter/:object/:method", :controller => "autocompleter", :action => "index"
      ActionController::Routing::Routes.add_route "/sortable/:object", :controller => "sortable", :action => "index", :conditions => {:method=>:put}
    end
  end
end