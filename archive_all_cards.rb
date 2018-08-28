#!/usr/bin/env ruby

require 'dotenv'
Dotenv.load

require 'octokit'

column_name = ARGV[0]

# find column
# Provide authentication credentials
github = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
github.auto_paginate = true

# Find the project ID
project_id = github.org_projects('apolitical').find{|x| x.name == "Engineering Sprint"}.id

# Find the column ID
column_id = github.project_columns(project_id).find{|x| x.name == column_name}.id

github.column_cards(column_id).each do |card|
  github.delete_project_card(card.id)
  puts "Archived #{card.note || card.content_url}"
end
