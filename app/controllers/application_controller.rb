class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Clearance::Controller
end
