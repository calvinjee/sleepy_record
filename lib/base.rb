require_relative 'db_connection'
require_relative 'associatable'
require_relative 'searchable'
require 'active_support/inflector'

module SleepyRecord
  class Base
    extend Searchable
    extend Associatable

    def self.table_name=(table_name)
      @table_name = table_name
    end

    def self.table_name
      @table_name || self.to_s.tableize
    end

    def self.columns
      unless @columns
        results = DBConnection.execute2(<<-SQL)
          SELECT *
          FROM #{self.table_name}
          LIMIT 1
        SQL
      end

      @columns ||= results.first.map(&:to_sym)
    end

    def self.finalize!
      columns.each do |column|
        define_method(column) do
          attributes[column]
        end

        define_method("#{column}=") do |value|
          attributes[column] = value
        end
      end
    end

    def self.all
      results = DBConnection.execute(<<-SQL)
        SELECT *
        FROM #{table_name}
      SQL
      self.parse_all(results)
    end

    def self.parse_all(results)
      results.map do |result|
        self.new(result)
      end
    end

    def self.find(id)
      self.all.find { |obj| obj.id == id }
    end

    def initialize(params = {})
      params.keys.each do |attr_name|
        raise "unknown attribute '#{attr_name}'" unless self.class.columns.include?(attr_name.to_sym)
      end

      params.each do |attr_name, value|
        self.send("#{attr_name}=", value)
      end
    end

    def attributes
      @attributes ||= {}
    end

    def attribute_values
      self.class.columns.map { |column| self.send(column) }
    end

    def insert
      cols = self.class.columns.drop(1)
      values = cols.map { |col| self.send(col) }
      question_marks = ["?"] * values.length

      DBConnection.execute(<<-SQL, *values)
        INSERT INTO
          #{self.class.table_name} (#{cols.join(", ")})
        VALUES
          (#{question_marks.join(", ")})
      SQL

      self.id = DBConnection.last_insert_row_id
    end

    def update
      set = self.class.columns.map { |column| "#{column} = ?" }

      DBConnection.execute(<<-SQL, *self.attribute_values)
        UPDATE #{self.class.table_name}
        SET #{set.join(", ")}
        WHERE id = #{self.id}
      SQL

      self.id
    end

    def save
      self.id.nil? ? self.insert : self.update
    end
  end

  trace = TracePoint.new(:end) do |tp|
    klass = tp.binding.receiver
    klass.finalize! if klass.respond_to? :finalize!
  end

  trace.enable
end
