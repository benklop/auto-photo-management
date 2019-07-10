# frozen_string_literal: true

module PhotoManagement
  class Config
    CONFIG_FILES = [
      '/etc/pmgr.yaml',
      "#{Dir.home}/.pmgr.yaml"
    ]

    def initialize
    end
  end
end
