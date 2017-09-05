# Sleepy Record
Inspired by Active Record for Rails, Sleepy Record is a library for Ruby to connect classes to relational databases.

## Example
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
## API - Mapping to the database

### Base

| Method     | Result        |
| ---------  |:--------------|
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
