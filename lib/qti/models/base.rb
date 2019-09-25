require 'nokogiri'
require 'pathname'
# require 'mathml2latex'
require 'qti/sanitizer'

module Qti
  class ParseError < StandardError; end
  class SpecificationViolation < StandardError; end
  class UnsupportedSchema < StandardError; end

  module Models
    class Base
      attr_reader :doc, :path, :package_root, :resource
      attr_accessor :manifest
      delegate :metadata, to: :@resource, allow_nil: true

      def sanitize_content!(html)
        sanitizer.clean(html)
      end

      def self.from_path!(path, package_root = nil, resource = nil)
        new(path: path, package_root: package_root, resource: resource)
      end

      def initialize(path:, package_root: nil, html: false, resource: nil)
        @path = path
        @resource = resource
        self.package_root = package_root || File.dirname(path)
        @doc = html ? parse_html(File.read(path)) : parse_xml(File.read(path))
        raise ArgumentError unless @doc
        @doc unless html
      end

*
      def xpath_with_single_check(xpath)
        node_list = @doc.xpath(xpath)
        raise Qti::ParseError, 'Too many matches' if node_list.count > 1
        node_list.first
      end

      def css_with_single_check(css)
        node_list = @doc.css(css)
        raise Qti::ParseError, 'Too many matches' if node_list.count > 1
        node_list.first
      end

      def parse_xml(xml_string)
        Nokogiri.XML(xml_string, @path.to_s, &:noblanks)
      end

      def parse_html(html_string)
        Nokogiri.HTML(html_string, @path.to_s, &:noblanks)
      end

      def remap_href_path(href)
        return nil unless href
        path = File.join(File.dirname(@path), href)
        if @package_root.nil?
          raise Qti::ParseError, "Potentially unsafe href '#{href}'" if href.split('/').include?('..')
        else
          unless Pathname.new(path).cleanpath.to_s.start_with?(@package_root)
            raise Qti::ParseError, "Unsafe href '#{href}'"
          end
        end
        path
      end

      def raise_unsupported(message = 'Unsupported QTI version')
        raise Qti::UnsupportedSchema, message
      end

      protected

      def package_root=(package_root)
        @package_root = package_root
        return unless @package_root
        @package_root = Pathname.new(@package_root).cleanpath.to_s + '/'
      end

      def relative_path
        return nil if @path.nil? || @package_root.nil?
        @path.sub(/\A#{Regexp.quote(@package_root)}/, '')
      end

      def copy_paths_from_item(other_item)
        @package_root = other_item.package_root
        @path = other_item.path
      end

      private

      def sanitizer
        @sanitizer ||= Sanitizer.new
      end
    end
  end
end
