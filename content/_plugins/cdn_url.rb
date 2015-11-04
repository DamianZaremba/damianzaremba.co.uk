require 'uri'

module Jekyll
    class CDNUrlTag < Liquid::Tag
		def initialize(tag_name, text, tokens)
			super
			@text = text
		end

		def render(context)
			uri = URI(@text)

			cdn_url = context.registers[:site].config['cdn_url'].gsub(/\/$/, '')
			file = File.expand_path(File.join(File.dirname(__FILE__), '..', uri.path))

			if not File.exist?(file)
				puts "Warning! /#{path} does not exist"
				return "#{cdn_url}/#{path}"
			end

			# Crappy caching :)
			if not context.registers.has_key?(:cdn_url)
				context.registers[:cdn_url] = {}
			end

			if context.registers[:cdn_url].has_key?(file)
				md5 = context.registers[:cdn_url][file]
			else
				md5 = Digest::MD5.file(file).hexdigest
			end

			# Add in the version
			params = URI.decode_www_form(uri.query || '') << ['_v', md5]
			uri.query = URI.encode_www_form(params)

			uri.to_s
		end
    end
end

Liquid::Template.register_tag('cdn_url', Jekyll::CDNUrlTag)