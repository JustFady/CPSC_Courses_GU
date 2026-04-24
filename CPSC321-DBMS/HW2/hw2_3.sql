/*===============================================================
 * NAME:   Fady Youssef
 * ASSIGN: HW-2, Question 2
 * COURSE: CPSC 321, Fall 2025
 * DESC:   Music schema (groups, musicians, genres, labels, albums,
 *         songs, tracks) with keys, constraints, and failing inserts.
 *==============================================================*/

-- drop tables for clean rebuild
DROP TABLE IF EXISTS album_track;
DROP TABLE IF EXISTS track_musician;
DROP TABLE IF EXISTS wrote;
DROP TABLE IF EXISTS membership;
DROP TABLE IF EXISTS influence;
DROP TABLE IF EXISTS group_genre;
DROP TABLE IF EXISTS track;
DROP TABLE IF EXISTS song;
DROP TABLE IF EXISTS album;
DROP TABLE IF EXISTS label;
DROP TABLE IF EXISTS genre;
DROP TABLE IF EXISTS musician;
DROP TABLE IF EXISTS mgroup;

-- mgroup(name, formed_yr)
CREATE TABLE mgroup (
  name       VARCHAR(80) PRIMARY KEY,
  formed_yr  INTEGER NOT NULL
);

-- musician(first_name, last_name, stage_name, birth_year)
CREATE TABLE musician (
  first_name VARCHAR(40) NOT NULL,
  last_name  VARCHAR(40) NOT NULL,
  stage_name VARCHAR(80),
  birth_year INTEGER,
  PRIMARY KEY (first_name, last_name)
);

-- genre(label, description)
CREATE TABLE genre (
  label       VARCHAR(40) PRIMARY KEY,
  description TEXT NOT NULL
);

-- label(name)
CREATE TABLE label (
  name VARCHAR(80) PRIMARY KEY
);

-- album(group_name, title, rec_year, label_name)
CREATE TABLE album (
  group_name VARCHAR(80)  NOT NULL REFERENCES mgroup(name),
  title      VARCHAR(120) NOT NULL,
  rec_year   INTEGER      NOT NULL,
  label_name VARCHAR(80)  NOT NULL REFERENCES label(name),
  PRIMARY KEY (group_name, title)
);

-- song(title, written_y)
CREATE TABLE song (
  title     VARCHAR(120) PRIMARY KEY,
  written_y INTEGER NOT NULL
);

-- group_genre(group_name, genre_label)
CREATE TABLE group_genre (
  group_name  VARCHAR(80) NOT NULL REFERENCES mgroup(name),
  genre_label VARCHAR(40) NOT NULL REFERENCES genre(label),
  PRIMARY KEY (group_name, genre_label)
);

-- influence(group_name, influenced_by)
CREATE TABLE influence (
  group_name    VARCHAR(80) NOT NULL REFERENCES mgroup(name),
  influenced_by VARCHAR(80) NOT NULL REFERENCES mgroup(name),
  PRIMARY KEY (group_name, influenced_by),
  CHECK (group_name <> influenced_by)
);

-- wrote(song_title, first_name, last_name)
CREATE TABLE wrote (
  song_title VARCHAR(120) NOT NULL REFERENCES song(title),
  first_name VARCHAR(40)  NOT NULL,
  last_name  VARCHAR(40)  NOT NULL,
  PRIMARY KEY (song_title, first_name, last_name),
  FOREIGN KEY (first_name, last_name)
    REFERENCES musician(first_name, last_name)
);

-- track(track_id, song_title, rec_year)
CREATE TABLE track (
  track_id   INTEGER      PRIMARY KEY,
  song_title VARCHAR(120) NOT NULL REFERENCES song(title),
  rec_year   INTEGER      NOT NULL
);

-- track_musician(track_id, first_name, last_name)
CREATE TABLE track_musician (
  track_id   INTEGER     NOT NULL REFERENCES track(track_id),
  first_name VARCHAR(40) NOT NULL,
  last_name  VARCHAR(40) NOT NULL,
  PRIMARY KEY (track_id, first_name, last_name),
  FOREIGN KEY (first_name, last_name)
    REFERENCES musician(first_name, last_name)
);

-- album_track(group_name, album_title, track_no, track_id)
CREATE TABLE album_track (
  group_name  VARCHAR(80)  NOT NULL,
  album_title VARCHAR(120) NOT NULL,
  track_no    INTEGER      NOT NULL,
  track_id    INTEGER      NOT NULL REFERENCES track(track_id),
  PRIMARY KEY (group_name, album_title, track_no),
  FOREIGN KEY (group_name, album_title)
    REFERENCES album(group_name, title)
);

-- membership(group_name, first_name, last_name, start_year, end_year)
CREATE TABLE membership (
  group_name VARCHAR(80) NOT NULL REFERENCES mgroup(name),
  first_name VARCHAR(40) NOT NULL,
  last_name  VARCHAR(40) NOT NULL,
  start_year INTEGER     NOT NULL,
  end_year   INTEGER,
  PRIMARY KEY (group_name, first_name, last_name),
  FOREIGN KEY (first_name, last_name)
    REFERENCES musician(first_name, last_name),
  CHECK (end_year IS NULL OR end_year >= start_year)
);

-- ===================== Failing INSERTs =====================

-- mgroup
-- INSERT INTO mgroup VALUES ('Nirvana', 1987);                 -- duplicate PK
-- INSERT INTO mgroup VALUES (NULL, 2000);                      -- NULL in PK

-- musician
-- INSERT INTO musician VALUES ('John','Lennon',NULL,1940);     -- duplicate PK
-- INSERT INTO musician VALUES (NULL,'Lennon',NULL,1940);       -- NULL in PK

-- genre
-- INSERT INTO genre VALUES ('rock','dup');                     -- duplicate PK
-- INSERT INTO genre (label) VALUES ('noise');                  -- missing description

-- label
-- INSERT INTO label VALUES ('Parlophone');                     -- duplicate PK
-- INSERT INTO label VALUES (NULL);                             -- NULL in PK

-- album
-- INSERT INTO album VALUES ('The Beatles','Revolver',1966,'Parlophone'); -- duplicate PK
-- INSERT INTO album VALUES ('The Beatles','Help!',1965,'NotARealLabel'); -- label FK fails

-- song
-- INSERT INTO song VALUES ('Kyoto',2021);                      -- duplicate PK
-- INSERT INTO song (title) VALUES (NULL);                      -- NULL in PK

-- group_genre
-- INSERT INTO group_genre VALUES ('The Beatles','rock');       -- duplicate PK
-- INSERT INTO group_genre VALUES ('NoGroup','rock');           -- group FK fails

-- influence
-- INSERT INTO influence VALUES ('Nirvana','Nirvana');          -- self-influence
-- INSERT INTO influence VALUES ('NoGroup','The Beatles');      -- group FK fails

-- wrote
-- INSERT INTO wrote VALUES ('Kyoto','Taylor','Swift');         -- musician FK fails
-- INSERT INTO wrote VALUES ('Eleanor Rigby','Paul','McCartney'); -- duplicate PK

-- track
-- INSERT INTO track VALUES (1001,'Eleanor Rigby',1966);        -- duplicate PK
-- INSERT INTO track VALUES (9999,'Nonexistent Song',2024);     -- song FK fails

-- track_musician
-- INSERT INTO track_musician VALUES (1001,'John','Lennon');    -- duplicate PK
-- INSERT INTO track_musician VALUES (9999,'John','Lennon');    -- track FK fails

-- album_track
-- INSERT INTO album_track VALUES ('The Beatles','Revolver',2,1001); -- duplicate PK
-- INSERT INTO album_track VALUES ('The Beatles','Help!',1,1001');   -- album FK fails

-- membership
-- INSERT INTO membership VALUES ('Nirvana','Dave','Grohl',1994,1993); -- end < start
-- INSERT INTO membership VALUES ('Unknown','John','Lennon',1960,1970); -- group FK fails

