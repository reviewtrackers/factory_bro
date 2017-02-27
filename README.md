# Factory Bro
[![Gem Version](https://badge.fury.io/rb/factory_bro.svg)](https://badge.fury.io/rb/factory_bro)

### Getting Started (from a Ruby console):
1. Connect To Database:
 - `FactoryBro.connect('identifier', 'dbName')` or `FactoryBro.connect('identifier', 'postgres://USER:PASSWORD@HOST:PORT/DBNAME')`
2. Create Base Factories
 - `FactoryBro.create_bases('identifier')`
2. Close Connection
 - `FactoryBro.close('identifier')`

### In Practice:

- `create_bases` produces all the potential factories your test suite will need with a guestimated corresponding Faker method for each column.
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
      FactoryBro.generate_data('identifier', states' , {
        "factoryData": {
          "id": id = Faker::Lorem.characters(32),
          "name": name = Faker::Address.state,
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
