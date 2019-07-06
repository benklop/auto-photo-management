module PhotoManagement
  class Folder
    class << self
      # look for XMP files in folder
      def scan(folder)
        []
      end

      # monitor for changed XMP files in folder, execute the block.
      def watch(folder)

      end
    end
  end
end
