# frozen_string_literal: true

require 'photo_management'
require 'thor'

class PhotoMgrCLI < Thor
  desc 'scan FOLDER', 'Scan all XMPs in FOLDER, rendering those that are out of date.'
  option :pretend, type: :boolean, default: false
  option :folder, type: :string, required: true
  def scan
    puts "Scanning for XMPs that need updating in #{options[:folder]} ..."

    PhotoManagement::Folder.scan(options[:folder]).each do |file_name|
      photo = PhotoManagement::Photo.new(file_name)
      photo.render(:jpeg) if photo.needs_rendering?
      photo.render(:intermediate) if photo.needs_intermediate?
      photo.render(:print) if photo.needs_print?

      next unless photo.rendered?

      photo.jpeg.link_to(:global_processed)
      photo.jpeg.link_to(:global_stock) if photo.xmp.tagged_for_stock?
    end
  end
end
