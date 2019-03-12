Gem::Specification.new do |s|
  s.name        = 'factory_bro'
  s.version     = '0.0.7'
  s.date        = '2017-02-10'
  s.summary     = "Factory Bro"
  s.description = "PSQL Parser and Data Generation similar to factory_girl"
  s.authors     = ["Nate Reynolds"]
  s.email       = 'nate@n8r.us'
  s.files       =  Dir['lib/**/*.rb']
  s.homepage    = 'https://github.com/nvreynolds/factory_bro'

  s.add_dependency("pg", "~> 1.1.4")
  s.add_dependency("faker", "~> 1.9.3")

  s.add_development_dependency("pry", "~> 0.10.4")
end
