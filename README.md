# Sleepy Record
Sleepy Record is a lightweight object-relational mapping modeled after Rails Active Record. This library provides a querying interface as well as the ability to construct associations between tables.

## Demo
1. Download or clone this repo and naviagate to `demo` directory.
2. Open up `pry` or `irb` and execute `load 'demo.rb'` in the console.
    * This will execute the `games.sql` file that creates the following tables and inserts some records into each:
      + Games
      + Characters
      + Weapons
3. Try out some of the methods you see below. For example:
    * `Game.all` will return an array of objects representing every record in the `Games` table.
    * `Character.columns` will show all columns for the table.
    * Create a new object with `Character.new` and pass in a hash to set its attributes where the key is the column name
    * Invoke `save` on the object to either create a new entry in the database or update an existing one.
    * Test out other commands such as `Weapon.first` or `Weapon.last`.
    * Every `Character` `belongs_to` a game so try `Character.last.game`.
    * A `Character` `has_many` weapons. Now try `Character.first.weapons`.
4. For a more complete list of methods, see below.

## How to Create Associations
Creating associations with SleepyRecord:
```
class Character < SleepyRecord::Base
  belongs_to :game,
    class_name: :Game,
    primary_key: :id,
    foreign_key: game_id

  has_many :weapons,
    class_name: :Character,
    primary_key: id;
    foreign_key: :owner_id
end
```
## API - Mapping to the Database

### Base

| Method     | Result        |
| ---------  |:--------------|
| ::all      | Array of all the database entries for the given table |
| ::columns  | Array of all column attributes |
| ::first    | Instance of the first record of the table |
| ::last     | Instance of the last record of the table |
| ::all      | Array of all the database entries for the given table |
| ::find(id) | SleepyRecord::Base object for the database record matching the id |
| ::new      | Creates instance in the respective table |
| #insert    | Inserts new record into database based on object attributes |
| #update    | Updates existing record into database based on object attributes |
| #save      | Either inserts or saves record whether not an id is defined as an attribute |

### Searchable

| Method    | Result        |
| --------- |:--------------|
| ::where   | Array of all records that meet the given parameters |


### Associatable

| Method            | Result        |
| ----------------- |:--------------|
| ::belongs_to      | Specifies one-to-one relationship from child to parent table |
| ::has_many        | Specifies one-to-many relationship from parent to child table |
| ::has_one_through | Specifies one-to-one relationship with a model by proceeding through another model |
