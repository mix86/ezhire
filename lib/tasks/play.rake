
task :play do
  city = 'москва'
  specializations = ['QA', 'test', 'tester', 'тестировщик', 'тестирование']

  digger = Digger.new city, specializations

  result = digger.call

  result.each { |p| puts "#{'*'*80}\n#{p.name} #{p.moikrug_link}, #{p.facebook_link}\n#{p.skills}\n#{'*'*80}" }

  puts 'WELL DONE!'
end
