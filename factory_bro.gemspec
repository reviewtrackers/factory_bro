Gem::Specification.new do |s|
  s.name        = 'factory_bro'
  s.version     = '0.0.4'
  s.date        = '2016-10-26'
  s.summary     = "Factory Bro"
  s.description = "PSQL Parser and Data Generation similar to factory_girl"
  s.authors     = ["Nate Reynolds"]
  s.email       = 'nate@n8r.us'
  s.files       =  Dir['lib/**/*.rb']
  s.homepage    = 'https://github.com/nvreynolds/factory_bro'

  s.add_dependency("pg", "~> 0.18.4")
  s.add_dependency("faker", "~> 1.6.6")

  s.add_development_dependency("pry", "~> 0.10.4")
end
