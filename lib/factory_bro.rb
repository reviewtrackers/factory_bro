require 'pg'
require 'faker'
require 'json'

class FactoryBro
  def self.connect(name, db)
    unless $conns
      $conns = {}
    else
      $conns.each do |key, conn|
        if conn.finished?
          $conns[key] = ''
        end
      end
    end
    if db.include? 'postgres://'
      dbData = parse_url(db)
      $conns[name] = PG.connect( user:     dbData[:user],
                          password: dbData[:pw],
                          host:     dbData[:host],
                          port:     dbData[:port],
                          dbname:   dbData[:dbname]
                        )
    else
      # take arguments of user and pw
      $conns[name] = PG.connect( dbname: db)
    end
  end

  def self.close(name)
    $conns[name].finish
    $conns[name] = ''
  end

  def self.close_all
    $conns.each do |key, conn|
      if conn.class == PG::Connection
        conn.finish
      end
    end
    $conns = nil
  end

  def self.exec(name, statement)
    run = $conns[name].exec(statement)
    run.values
  end

  def self.create_bases(name)
    tables = parse_tables(name)
    system 'mkdir', '-p', 'factories' unless File.directory?(Dir.pwd+"/factories")
    tables.each do |table|
      path = File.join(Dir.pwd, 'factories', "#{table}.rb")
      unless File.exists?(path)

        File.open(path, 'w') {|file| file.write(base_factory_content(name, table)) }
        # puts "#{table} factory created at: #{path}"
      end
    end
  end

  def self.generate_data(name, table, data)
    helperData = generate_helper(data[:factoryData])
    res = $conns[name].exec(name, "INSERT INTO #{table} (#{helperData[:columns]})
    VALUES (#{helperData[:values]});")
    data[:meta]
  end

  private

  def self.parse_url(url)
    { :user     => url.scan(/postgres:..[A-Za-z0-9]+/).first.split('//')[-1],
      :pw       => url.scan(/:[A-Za-z0-9]+@/).first.gsub(/[^a-zA-Z0-9\-]/,""),
      :host     => url.scan(/(?<=@)(.*)(?=:)/).first.first,
      :port     => url.scan(/:[0-9]+./).first.split('/').first.gsub(/[^a-zA-Z0-9\-]/,""),
      :dbname   => url.scan(/.[A-Za-z0-9]+$/).first.gsub(/[^a-zA-Z0-9\-]/,"")
    }
  end

  def self.parse_tables(name)
    res = $conns[name].exec(name, "SELECT TABLE_NAME
                      FROM INFORMATION_SCHEMA.TABLES
                      WHERE TABLE_TYPE = 'BASE TABLE' AND TABLE_SCHEMA='public'
                      ORDER BY TABLE_NAME;")
    res.values.flatten # as array of column names
  end

  def self.parse_columns(table)
    # hash this
    res = $conns[name].exec(name, " SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
                      FROM INFORMATION_SCHEMA.COLUMNS
                      WHERE TABLE_NAME = '#{table}';")
    res.values # as tuple
  end

  def self.base_factory_content(name, table)
    "module Factory
  class #{table.split('_').map { |word| word.capitalize }.join}
    def self.base
      # remember:
      # to return any needed metadata (i.e. ID)
      # run other required bases before running method below
      FactoryBro.generate_data(#{name}, '#{table}' , #{base_method_helper(table)})
    end
  end
end
"
  end

  def self.base_method_helper(table)
    data = {}
    parse_columns(table).each do |column|
      data.merge!(column.first => auto_faker_assignment(column)) # idk if auto faker assignment is helping or a burden?
    end
    JSON.pretty_generate({ "factoryData" => data, "meta"=> {}})
  end

  def self.auto_faker_assignment(column)
    type = column[1] # hash this
    name = column.first
    if type == "character varying"
      if name.include? 'sign_in_ip'
        return "Faker::Internet.ip_v4_address"
      elsif name == 'email'
        return "Faker::Internet.safe_email"
      else
        return "Faker::Lorem.characters(32)"
      end
    elsif type == "text"
      return "# password and password salt? don't know what to return"
    elsif type == "integer"
      return "rand(0...1000)"
    elsif type == "boolean"
      return "Faker::Boolean.boolean"
    elsif type == "timestamp with time zone"
      return "Faker::Time.between(DateTime.now - 1, DateTime.now)"
    else
      "# could not determine type: #{type}"
    end
  end

  def self.generate_helper(data)
    formatted = data.to_a
    columns = "#{formatted.first.first.to_s}"
    values = "'#{formatted.first.last}'"
    formatted.shift
    formatted.each do |column|
      columns += ", #{column.first.to_s}"
      values += ", '#{column.last}'"
    end
    { columns: columns, values: values}
  end
end
