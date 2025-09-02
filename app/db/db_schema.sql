-- COMPETITION
CREATE TABLE competition (
    id SERIAL PRIMARY KEY
    -- add fields like name, season, etc.
);

-- MATCH
CREATE TABLE match (
    id SERIAL PRIMARY KEY,
    competition_id INT REFERENCES competition(id),
    match_date DATE
);

-- TEAM
CREATE TABLE team (
    id SERIAL PRIMARY KEY,
    name TEXT
);

-- TEAM_GAME (link: team <-> match)
CREATE TABLE team_game (
    id SERIAL PRIMARY KEY,
    team_id INT NOT NULL REFERENCES team(id),
    match_id INT NOT NULL REFERENCES match(id)
);

-- PLAYER
CREATE TABLE player (
    id SERIAL PRIMARY KEY,
    team_id INT REFERENCES team(id)
    -- add player details (name, dob, position...)
);

-- ROLE (link: player <-> team_game)
CREATE TABLE role (
    id SERIAL PRIMARY KEY,
    player_id INT NOT NULL REFERENCES player(id),
    team_game_id INT NOT NULL REFERENCES team_game(id)
    -- role fields: starter, captain, etc.
);

-- TRACKING (link: player <-> team_game)
CREATE TABLE tracking (
    id SERIAL PRIMARY KEY,
    player_id INT NOT NULL REFERENCES player(id),
    team_game_id INT NOT NULL REFERENCES team_game(id)
    -- add tracking metrics
);

-- BALL TRACKING (link: match)
CREATE TABLE ball_tracking (
    id SERIAL PRIMARY KEY,
    match_id INT NOT NULL REFERENCES match(id)
    -- ball tracking data fields
);

-- REFEREE
CREATE TABLE referee (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- REFEREE_GAME (link: referee <-> match)
CREATE TABLE referee_game (
    id SERIAL PRIMARY KEY,
    referee_id INT NOT NULL REFERENCES referee(id),
    match_id INT NOT NULL REFERENCES match(id),
    type VARCHAR(255)
);

-- ACTION DOCUMENT / VIDEO (1 per game)
CREATE TABLE action_document (
    id SERIAL PRIMARY KEY,
    team_game_id INT NOT NULL REFERENCES team_game(id),
    file_path TEXT  -- or metadata
);

CREATE TABLE action_video (
    id SERIAL PRIMARY KEY,
    team_game_id INT NOT NULL REFERENCES team_game(id),
    file_path TEXT
);

-- ACTIONS (specialized tables)
CREATE TABLE pass (
    id SERIAL PRIMARY KEY,
    player_id INT NOT NULL REFERENCES player(id),
    action_document_id INT REFERENCES action_document(id),
    action_video_id INT REFERENCES action_video(id)
    -- add fields like pass_type, distance, outcome...
);

CREATE TABLE duel (
    id SERIAL PRIMARY KEY,
    player_id INT NOT NULL REFERENCES player(id),
    action_document_id INT REFERENCES action_document(id),
    action_video_id INT REFERENCES action_video(id)
    -- duel_type, won/lost, opponent_id...
);

CREATE TABLE assist (
    id SERIAL PRIMARY KEY,
    player_id INT NOT NULL REFERENCES player(id),
    action_document_id INT REFERENCES action_document(id),
    action_video_id INT REFERENCES action_video(id)
    -- assist_type...
);

CREATE TABLE goal (
    id SERIAL PRIMARY KEY,
    player_id INT NOT NULL REFERENCES player(id),
    action_document_id INT REFERENCES action_document(id),
    action_video_id INT REFERENCES action_video(id)
    -- goal_type, minute...
);

CREATE TABLE card (
    id SERIAL PRIMARY KEY,
    player_id INT NOT NULL REFERENCES player(id),
    card_type VARCHAR(20), -- yellow/red
    action_document_id INT REFERENCES action_document(id),
    action_video_id INT REFERENCES action_video(id)
);

CREATE TABLE freekick (
    id SERIAL PRIMARY KEY,
    player_id INT NOT NULL REFERENCES player(id),
    action_document_id INT REFERENCES action_document(id),
    action_video_id INT REFERENCES action_video(id)
    -- direct/indirect, outcome...
);

-- TRAINING + EXERCISES
CREATE TABLE training (
    id SERIAL PRIMARY KEY,
    team_id INT NOT NULL REFERENCES team(id)
);

CREATE TABLE training_exercise (
    id SERIAL PRIMARY KEY,
    training_id INT NOT NULL REFERENCES training(id)
);

-- WELLNESS & SATISFACTION TESTS
CREATE TABLE wellness_test (
    id SERIAL PRIMARY KEY,
    player_id INT NOT NULL REFERENCES player(id)
);

CREATE TABLE satisfaction_test (
    id SERIAL PRIMARY KEY,
    player_id INT NOT NULL REFERENCES player(id)
);

-- PHYSICAL TEST
CREATE TABLE physical_test (
    id SERIAL PRIMARY KEY,
    player_id INT NOT NULL REFERENCES player(id)
);

-- INJURY + BODYPART
CREATE TABLE injury (
    id SERIAL PRIMARY KEY,
    player_id INT NOT NULL REFERENCES player(id)
);

CREATE TABLE bodypart (
    id SERIAL PRIMARY KEY,
    injury_id INT NOT NULL REFERENCES injury(id)
);

-- STAFF
CREATE TABLE staff (
    id SERIAL PRIMARY KEY
);

-- STAFF TEAM (link: staff <-> team)
CREATE TABLE staff_team (
    id SERIAL PRIMARY KEY,
    staff_id INT NOT NULL REFERENCES staff(id),
    team_id INT NOT NULL REFERENCES team(id)
);

-- STAFF GAME (link: staff <-> team_game)
CREATE TABLE staff_game (
    id SERIAL PRIMARY KEY,
    staff_id INT NOT NULL REFERENCES staff(id),
    team_game_id INT NOT NULL REFERENCES team_game(id)
);

-- ACTION DOCUMENT STAFF (link: staff <-> team_game)
CREATE TABLE action_document_staff (
    id SERIAL PRIMARY KEY,
    staff_id INT NOT NULL REFERENCES staff(id),
    team_game_id INT NOT NULL REFERENCES team_game(id)
);

-- NATION (link: player & staff)
CREATE TABLE nation (
    id SERIAL PRIMARY KEY,
    staff_id INT REFERENCES staff(id),
    player_id INT REFERENCES player(id)
);
