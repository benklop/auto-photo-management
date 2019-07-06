# frozen_string_literal: true

require 'photo_management'
require 'thor'

class PhotoMgrCLI < Thor
  desc 'scan FOLDER', 'Scan all XMPs in FOLDER, rendering those that are out of date.'
  option :pretend, type: :boolean, default: false
  option :folder, type: :string, required: true
  def scan
    puts "Scanning for XMPs that need updating in #{options[:folder]} ..."

    file_names = PhotoManagement::Folder.scan(options[:folder])
    photos = file_names.map { |file_name| PhotoManagment::Photo.new(file_name) }
    photos.each do |photo|
      photo.render if photo.needs_rendering?
      next unless photo.rendered?

      # link to the processed folder always
      photo.jpeg.link_to(:processed) if photo.rendered? && photo.xmp.tagged_for_personal_use?
      photo.jpeg.link_to(:prints) if photo.xmp.tagged_for_prints?
    end
  end
end
