<<<<<<< HEAD

FactoryGirl.define do
  factory :student do
    first_name 'Larry'
    last_name 'Ellison'
    education 'Master of Sailing'
    academic_program 'Volkswirtschaftslehre'
    homepage 'oracle.com'
    github 'larryAwesome'
    facebook 'larry2harry'
    xing 'theLarry'
    linkedin 'notHasso'
    languages {Language.create([{name: 'Englisch'}])}
    programming_languages  {ProgrammingLanguage.create([{ name: 'Ruby'}])}
  end
=======

FactoryGirl.define do
  factory :student do
    first_name 'Larry'
    last_name 'Ellison'
    education 'Master of Sailing'
    academic_program 'Volkswirtschaftslehre'
    homepage 'oracle.com'
    github 'larryAwesome'
    facebook 'larry2harry'
    xing 'theLarry'
    linkedin 'notHasso'
  end
>>>>>>> origin/develop-js-student-profile
end