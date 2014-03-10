module Admin
  class DashboardController < ActiveAdmin::Dashboards::DashboardController
    def resource_path(resource)
      polymorphic_path [:admin, resource]
    end
  end
end
