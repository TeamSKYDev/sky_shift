# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(
	id: 0,
	email: "help@help",
	password: "helphelp",
	telephone_number: "help",
	is_unsubscribe: true,
	last_name: "ヘルプ",
	first_name: "help",
)