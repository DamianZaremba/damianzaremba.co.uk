# Initial module from https://github.com/indirect/jekyll-postfiles
# hacked around a bunch to make it work with my urls and love for absolute urls
# Also added a Site class to stick stuff in site.static_files so it doesn't get cleaned
module Jekyll
    class PostFile < StaticFile
        def path
            File.join(@base, @name)
        end
    end

    class Postfiles < Generator
        safe true
        priority :lowest

        def generate(site)
            site.posts.each do |post|
                postfile_id = post.id.gsub(/(\d{4})\/(\d\d)\/(.*)/, '\1-\2-\3')
                postfile_dir = File.absolute_path(File.join(site.config['source'], '_postfiles', postfile_id))

                Dir[File.join(postfile_dir, '/*')].each{|pf|
                    site.static_files << PostFile.new(site, postfile_dir, post.url, File.basename(pf))
                }
            end
        end
    end

    class PostfileTag < Liquid::Tag
        def initialize(tag_name, text, tokens)
            super
            @text = text
        end

        def render(context)
            File.join(context['page']['url'], @text)
        end
    end
end

Liquid::Template.register_tag('postfile', Jekyll::PostfileTag)
