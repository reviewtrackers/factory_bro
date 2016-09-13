# Factory Bro

### Getting Started:
1. Connect To Database:
 - `FactoryBro.connect(dbName)`
2. Create Base Factories
 - `FactoryBro.create_bases`
 
### In Practice:

- `create_bases` produces all the potential factories your test suite will need with a guestimated corresponding Faker method. 
 - You can call it later if you add more tables.
 - Editing is required after you generate these samples.
- You must require the factories created in your test helper similar to something like this:
```
def require_glob(glob)
  Dir[glob].sort.each { |f| require f }
end

File.expand_path(__dir__).tap do |base|
  require_glob File.join(base, 'factories', '*.rb')
  # page objects, contexts, helpers, etc
end
```
- In your tests then call the factory: `Factory::Table.factory_method` (be sure to include any needed metadata in your factories)

### Sample generated (post edit factory)
```
module Factory
  class States
    def self.base
      id = Faker::Lorem.characters(32)
      name = Faker::Address.state
      FactoryBro.generate_data('states' , {
        "factoryData": {
          "id": id,
          "name": name,
          "code": Faker::Address.state_abbr,
          "active": Faker::Boolean.boolean,
          "country_id": Faker::Lorem.characters(32),
          "created_at": Faker::Time.between(DateTime.now - 1, DateTime.now),
          "updated_at": Faker::Time.between(DateTime.now - 1, DateTime.now)
        },
        "meta": { "id": id,
          "name": name
        }
      })
    end
  end
end

```
calling would be: `Factory::States.base`
