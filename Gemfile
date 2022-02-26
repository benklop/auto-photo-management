# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem "watchman", "~> 0.1.1"
gem "nokogiri", "~> 1.13"

group :cli do
  gem "thor", "~> 0.20.3"
end
group :gui do
  gem "fxruby", "~> 1.6.40"
end

group :develop do
  gem "rspec", "~> 3.8"
  gem "rubocop", "~> 0.68.1"
end
