Gem::Specification.new do |s|
  s.name        = 'factory_bro'
  s.licenses    = ['MIT']
  s.version     = '0.0.11'
  s.date        = '2024-05-30'
  s.summary     = "Factory Bro"
  s.description = "PSQL Parser and Data Generation similar to factory_girl"
  s.authors     = ["Nate Reynolds"]
  s.email       = 'nate@n8r.us'
  s.files       =  Dir['lib/**/*.rb']
  s.homepage    = 'https://github.com/nvreynolds/factory_bro'

  s.add_dependency("pg", "~> 1.5.6")
  s.add_dependency("faker", "~> 3.4.1")

  s.add_development_dependency("pry", "~> 0.14.2")
end
