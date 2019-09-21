# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Record.where(name: 'Hiep Dinh', imm_type: 'f2b', priority_date: Time.strptime('17/08/2018', '%d/%m/%Y')).first_or_create

VisaBulletin.where(uuid: '201907').first_or_create(
  data: {
    f1: Time.parse('2012-03-08 00:00:00 +0700'),
    f2a: 'C',
    f2b: Time.parse('2013-09-01 00:00:00 +0700'),
    f3: Time.parse('2007-03-08 00:00:00 +0700'),
    f4: Time.parse('2006-06-15 00:00:00 +0700')
  }
)

VisaBulletin.where(uuid: '201908').first_or_create(
  data: {
    f1: Time.parse('2012-07-01 00:00:00 +0700'),
    f2a: 'C',
    f2b: Time.parse('2014-01-01 00:00:00 +0700'),
    f3: Time.parse('2007-06-22 00:00:00 +0700'),
    f4: Time.parse('2006-10-01 00:00:00 +0700')
  }
)


