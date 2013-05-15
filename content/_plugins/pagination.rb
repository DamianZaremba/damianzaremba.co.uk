# Drop into content/_plugins/pagination.rb
# Outputs pages into /1/ /2/ /3/ /4/ etc
module Jekyll
    module Generators
        class Pager < Pager
            def self.paginate_path(site_config, num_page)
                return nil if num_page.nil? || num_page <= 1
                 "/%d" % num_page
            end
        end
    end
end
