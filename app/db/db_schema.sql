-- Competition table
CREATE TABLE Competition (
    id BIGINT PRIMARY KEY,
    year VARCHAR,
    name BIGINT,
    level SMALLINT,
    type VARCHAR
);

-- Match table
CREATE TABLE Match (
    id BIGINT PRIMARY KEY,
    referee BIGINT,
    stadium VARCHAR,
    date DATE,
    video VARCHAR,
    matchday INT,
    "group" SMALLINT,
    competition_id BIGINT REFERENCES Competition(id)
);

-- Team table
CREATE TABLE Team (
    id BIGINT PRIMARY KEY
);

-- Team_Standing table
CREATE TABLE Team_Standing (
    id BIGINT PRIMARY KEY,
    position BIGINT,
    points BIGINT,
    matchday BIGINT,
    competition_id BIGINT REFERENCES Competition(id),
    team_id BIGINT REFERENCES Team(id)
);

-- Knockout table
CREATE TABLE Knockout (
    id BIGINT PRIMARY KEY,
    round VARCHAR,
    team_id BIGINT REFERENCES Team(id)
);

-- Team_Game table
CREATE TABLE Team_Game (
    id BIGINT PRIMARY KEY,
    is_host BOOLEAN,
    points SMALLINT,
    match_id BIGINT REFERENCES Match(id),
    team_id BIGINT REFERENCES Team(id)
);

-- Action_Video table
CREATE TABLE Action_Video (
    id BIGINT PRIMARY KEY,
    timestamp TIMESTAMP,
    position_x FLOAT,
    position_y FLOAT,
    type VARCHAR,
    minute INT,
    half SMALLINT,
    team_game_id BIGINT REFERENCES Team_Game(id)
);

-- Action_Document table
CREATE TABLE Action_Document (
    id BIGINT PRIMARY KEY,
    type VARCHAR,
    minute INT,
    half SMALLINT,
    team_game_id BIGINT REFERENCES Team_Game(id)
);

-- Player table
CREATE TABLE Player (
    id BIGINT PRIMARY KEY
);

-- Pass table
CREATE TABLE Pass (
    id BIGINT PRIMARY KEY,
    action_id BIGINT REFERENCES Action_Video(id),
    player_id BIGINT REFERENCES Player(id)
);

-- Shot table
CREATE TABLE Shot (
    id BIGINT PRIMARY KEY,
    action_id BIGINT REFERENCES Action_Video(id),
    player_id BIGINT REFERENCES Player(id)
);

-- Fault table
CREATE TABLE Fault (
    id BIGINT PRIMARY KEY,
    action_id BIGINT REFERENCES Action_Video(id),
    player_id BIGINT REFERENCES Player(id)
);

-- Interception table
CREATE TABLE Interception (
    id BIGINT PRIMARY KEY,
    action_id BIGINT REFERENCES Action_Video(id),
    player_id BIGINT REFERENCES Player(id)
);

-- Duel table
CREATE TABLE Duel (
    id BIGINT PRIMARY KEY,
    action_id BIGINT REFERENCES Action_Video(id),
    player_id BIGINT REFERENCES Player(id)
);

-- Clearance table
CREATE TABLE Clearance (
    id BIGINT PRIMARY KEY,
    action_id BIGINT REFERENCES Action_Video(id),
    player_id BIGINT REFERENCES Player(id)
);
