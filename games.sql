CREATE TABLE weapons (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  owner_id INTEGER,

  FOREIGN KEY(owner_id) REFERENCES characters(id)
);

CREATE TABLE characters (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  game_id INTEGER,

  FOREIGN KEY(game_id) REFERENCES games(id)
);

CREATE TABLE games (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL
);

INSERT INTO
  games (id, title)
VALUES
  (1, "Super Smash Bros Melee"), (2, "Diablo");

INSERT INTO
  characters (id, name, game_id)
VALUES
  (1, "Link", 1),
  (2, "Ness", 1),
  (3, "Sorceress", 2),
  (4, "Amazon", 2);

INSERT INTO
  weapons (id, name, owner_id)
VALUES
  (1, "Master Sword", 1),
  (2, "Baseball Bat", 2),
  (3, "Oculus", 3),
  (4, "Buriza", 4);
