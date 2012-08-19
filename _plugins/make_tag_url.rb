module Jekyll
	module MakeTagUrlFilter
		def make_tag_url(tag_name)
        	 "/tag/#{tag_name.downcase.gsub(/\s+/, '-')}"
        end
    end
end

Liquid::Template.register_filter(Jekyll::MakeTagUrlFilter)
