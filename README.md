# Sprint Scripts

Some useful scripts for managing our GitHub sprint project board.

## Requirements

Ruby 2.5.0

## Installation

`bundle install`

create a file called `.env` containing:

```
GITHUB_TOKEN={a github oauth token with access to your project}
```

## Usage

### Archiving cards

`./archive_all_cards.rb '{column_name}'` will remove all cards from the named column from the Apolitical sprint planning board.

### Counting points

`./count_points.rb '{column_name},{column_name},{column_name}'` will count points on all cards in the named columns. It will also count up any cards marked as additions.
