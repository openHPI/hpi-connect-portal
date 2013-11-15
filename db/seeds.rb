# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

JobOffer.create(
	:title => 'Supporting the lab operations of the chair',
	:description => 'We want you to help in implementing a new modelling tool designed for embedded systems',
	:chair => 'System Analysis and Modeling',
	:start_date => Date.new(2013, 10, 1),
	:end_date => Date.new(2014, 03, 31),
	:time_effort => 7,
	:compensation => 10)


ProgrammingLanguage.create(name: "C")
ProgrammingLanguage.create(name: "C++")
ProgrammingLanguage.create(name: "Java")
ProgrammingLanguage.create(name: "Javascript")
ProgrammingLanguage.create(name: "Python")
ProgrammingLanguage.create(name: "Ruby")
ProgrammingLanguage.create(name: "Smalltalk")
