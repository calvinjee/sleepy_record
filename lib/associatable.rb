require_relative 'searchable'
require 'active_support/inflector'

class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    self.class_name.to_s.constantize
  end

  def table_name
    self.model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    defaults = {
      foreign_key: "#{name}_id".to_sym,
      primary_key: :id,
      class_name: name.to_s.camelize
    }
    options = defaults.merge(options)

    @foreign_key = options[:foreign_key]
    @class_name = options[:class_name]
    @primary_key = options[:primary_key]
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    defaults = {
      foreign_key: "#{self_class_name.underscore}_id".to_sym,
      primary_key: :id,
      class_name: name.to_s.singularize.camelize
    }
    options = defaults.merge(options)

    @foreign_key = options[:foreign_key]
    @class_name = options[:class_name]
    @primary_key = options[:primary_key]
  end
end

module Associatable
  def assoc_options
    @assoc_options ||= {}
  end

  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)
    assoc_options[name] = options

    define_method(name) do
      foreign_key_value = self.send(options.foreign_key)
      primary_key = options.primary_key
      target_model = options.model_class

      results = target_model.where(primary_key => foreign_key_value)
      results.first
    end
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self.name, options)
    assoc_options[name] = options

    define_method(name) do
      foreign_key = options.foreign_key
      primary_key_value = self.send(options.primary_key)
      target_model = options.model_class

      target_model.where(foreign_key => primary_key_value)
    end
  end

  def has_one_through(name, through_name, source_name)
    define_method(name) do

      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]
      foreign_key_val = self.send(through_options.foreign_key)

      through_table_name = through_options.table_name
      source_table_name = source_options.table_name

      results = DBConnection.execute(<<-SQL, foreign_key_val)
        SELECT #{source_table_name}.*
        FROM #{through_table_name}
        JOIN #{source_table_name}
          ON #{source_table_name}.id = #{through_table_name}.#{source_options.foreign_key.to_s}
        WHERE #{through_table_name}.id = ?
      SQL

      source_options.model_class.parse_all(results).first
    end
  end

end

class SQLObject
  extend Associatable
end
