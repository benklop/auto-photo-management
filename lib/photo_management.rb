# frozen_string_literal: true

require 'nokogiri'
require_relative 'photo_management/rendered_file'
require_relative 'photo_management/raw_file'
require_relative 'photo_management/xmp_file'
require_relative 'photo_management/darktable'
require_relative 'photo_management/folder'

module PhotoManagement
  class Photo
    attr_reader :jpeg
    attr_reader :intermediate
    attr_reader :print
    attr_reader :raw
    attr_reader :xmp
    attr_reader :renderer

    def initialize(xmp_file)
      @xmp = XMPFile.new(xmp_file)

      render_name = File.basename(File.basename(xmp.file_name, '.xmp'), '.*')

      @jpeg = RenderedFile.new(
        File.join(
          File.dirname(xmp.file_name),
          '../Processed',
          render_name + '.jpg'
        )
      )

      @intermediate = RenderedFile.new(
        File.join(
          File.dirname(xmp.file_name),
          '../Intermediate',
          render_name + '.tiff'
        )
      )

      @print = RenderedFile.new(
        File.join(
          File.dirname(xmp.file_name),
          '../Prints',
          render_name + '.tiff'
        )
      )

      @raw = RawFile.new(
        File.join(
          File.dirname(xmp.file_name),
          xmp.source_file_name
        )
      )

      @renderer = Darktable if xmp.type == :darktable
    end

    def rendered?
      jpeg.exist?
    end

    def needs_rendering?
      xmp.tagged_ready_for_rendering? && xmp.updated_at > jpeg.updated_at
    end

    def needs_intermediate?
      xmp.tagged_for_intermediate? && xmp.updated_at > intermediate.updated_at
    end

    def needs_print?
      xmp.tagged_for_print? && xmp.updated_at > print.updated_at
    end

    def render(type = :jpeg)
      case type
      when :jpeg
        renderer.render(xmp.file_name, raw.file_name, jpeg.file_name)
      when :intermediate
        renderer.render(xmp.file_name, raw.file_name, intermediate.file_name)
      when :print
        renderer.render(xmp.file_name, raw.file_name, print.file_name)
      else
        raise "Cannot render type '#{type}'!"
      end
    end
  end
end
