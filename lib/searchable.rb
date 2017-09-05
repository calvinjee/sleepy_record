require_relative 'db_connection'

module Searchable
  def where(params)
    filters = params.keys.map { |key| "#{key} = ?" }

    results = SleepyRecord::DBConnection.execute(<<-SQL, *params.values)
      SELECT *
      FROM #{self.table_name}
      WHERE #{filters.join(' AND ')}
    SQL

    self.parse_all(results)
  end
end
