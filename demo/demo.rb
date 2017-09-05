require_relative '../lib/base'
require_relative '../lib/db_connection'

GAMES_SQL_FILE = 'games.sql'
GAMES_DB_FILE = 'games.db'

`rm '#{GAMES_DB_FILE}'`
`cat '#{GAMES_SQL_FILE}' | sqlite3 '#{GAMES_DB_FILE}'`

SleepyRecord::DBConnection.open(GAMES_DB_FILE)

class Game < SleepyRecord::Base
  has_many :characters,
    class_name: :Character,
    primary_key: :id,
    foreign_key: :game_id
end

class Character < SleepyRecord::Base
  belongs_to :game

  has_many :weapons,
    foreign_key: :owner_id
end

class Weapon < SleepyRecord::Base
  belongs_to :owner,
    class_name: :Character,
    primary_key: :id,
    foreign_key: :owner_id

  has_one_through :game,
    through: :owner,
    source: :game
end
