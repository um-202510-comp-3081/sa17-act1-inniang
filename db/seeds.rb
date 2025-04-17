# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
BoardGame.destroy_all

BoardGame.create!([
  {
    title: "Catan",
    category: "Strategy",
    min_players: 3,
    max_players: 4,
    publisher: "Kosmos",
    description: "A resource-trading game where players build settlements on the island of Catan."
  },
  {
    title: "Ticket to Ride",
    category: "Family",
    min_players: 2,
    max_players: 5,
    publisher: "Days of Wonder",
    description: "Players compete to build train routes across North America."
  },
  {
    title: "Uno",
    category: "Card",
    min_players: 2,
    max_players: 10,
    publisher: "Mattel",
    description: "A fast-paced card game where players try to get rid of all their cards."
  },
  {
    title: "7 Wonders",
    category: "Strategy",
    min_players: 2,
    max_players: 7,
    publisher: "Repos Production",
    description: "Draft cards and build a civilization through 3 ages."
  }
])
