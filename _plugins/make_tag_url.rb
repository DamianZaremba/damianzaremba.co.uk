module Jekyll
    class MakeTagUrlTag < Liquid::Tag
        def initialize(tag_name, text, tokens)
            super
            @text = text
        end

        def render(context)
        	@text.gsub(/\s+/, '-').downcase
        end
    end
end

Liquid::Template.register_tag('make_tag_url', Jekyll::MakeTagUrlTag)
