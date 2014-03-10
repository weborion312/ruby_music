ActiveAdmin::Dashboards.build do
  section 'Recent Users', :priority => 1 do
    insert_tag ActiveAdmin::Views::IndexAsTable::IndexTableFor, User.recent.limit(10) do
      id_column
      column :username
      column :email
    end
  end

  section 'Recent Tracks', :priority => 3 do
    insert_tag ActiveAdmin::Views::IndexAsTable::IndexTableFor, Track.recent.limit(10) do
      id_column
      column :name
      column 'Owner', :user
    end
  end
end

# CUstom menu entries
module ActiveAdmin
  module Views
    class HeaderRenderer
      def to_html
        title + global_navigation + custom_links + utility_navigation
      end

      def custom_links
        link_to 'CMS', '/refinery'
      end
    end
  end
end
