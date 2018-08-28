#!/usr/bin/env ruby

require 'dotenv'
Dotenv.load

require 'octokit'

# find column
# Provide authentication credentials
def github()
  @github ||= Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
  @github.auto_paginate = true
  @github
end

def issue_cards(column_id)
  []
end

def issue(card)
  match = card.content_url.match(/repos\/apolitical\/(.*?)\/issues\/(\d+)/)
  return nil unless match
  i = github.issue("apolitical/#{match[1]}", match[2])
  return i.pull_request ? nil : i;
end

def size(issue)
  issue.labels.map{|l| l.name}.select{|l| l.include?('size')}.map{|x| x.match(/\d+/)[0].to_i}[0]
end

def addition?(issue)
  issue.labels.map{|l| l.name}.any?{|l| l.include?('addition')}
end

column_names = ARGV[0].split(',')

# Find the project ID
project_id = github.org_projects('apolitical').find{|x| x.name == "Engineering Sprint"}.id

# track additions
all_additions = []
all_addition_sizes = []

column_names.each do |column_name|

  # Find the column ID
  column_id = github.project_columns(project_id).find{|x| x.name == column_name}.id

  # get cards
  cards = github.column_cards(column_id)
  issues = cards.map{|x| issue(x)}.compact

  sizes = issues.map{|x| size(x)}.compact
  additions = issues.select{|issue| addition?(issue)}
  addition_sizes = additions.map{|x| size(x)}.compact
  all_additions += additions
  all_addition_sizes += addition_sizes

  puts "#{column_name}: #{issues.count} cards, #{sizes.inject(0, :+)} points"

end

puts "Additions: #{all_additions.count} cards, #{all_addition_sizes.inject(0, :+)} points"
