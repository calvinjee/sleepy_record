require_relative 'db_connection'
require_relative 'sql_object'

module Searchable
  def where(params)
    filters = params.keys.map { |key| "#{key} = ?" }

    results = DBConnection.execute(<<-SQL, *params.values)
      SELECT *
      FROM #{self.table_name}
      WHERE #{filters.join(' AND ')}
    SQL
    self.parse_all(results)
  end
end

class SQLObject
  extend Searchable
end
