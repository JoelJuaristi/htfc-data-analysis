-- Merged Football Database Schema
-- Consolidated from 3 pieces with Team_Standing, Knockout, and generic Actions tables removed

-- Core Competition and Match tables
CREATE TABLE Competition (
    id BIGINT PRIMARY KEY,
    year VARCHAR,
    name VARCHAR,
    level SMALLINT,
    type VARCHAR,
    location VARCHAR,
    region BIGINT
);

CREATE TABLE Match (
    id BIGINT PRIMARY KEY,
    round VARCHAR(7),
    referee BIGINT,
    stadium VARCHAR,
    date DATE,
    video VARCHAR,
    matchday INT,
    "group" SMALLINT,
    competition_id BIGINT REFERENCES Competition(id)
);

-- Core Team and Player tables
CREATE TABLE Team (
    id BIGINT PRIMARY KEY
);

CREATE TABLE Player (
    id BIGINT PRIMARY KEY
);

-- Nationality and Staff management
CREATE TABLE nationality (
    id BIGINT PRIMARY KEY
);

CREATE TABLE staff (
    id BIGINT PRIMARY KEY,
    nationality_id BIGINT REFERENCES nationality(id)
);

CREATE TABLE staff_team (
    id BIGINT PRIMARY KEY,
    year BIGINT,
    type BIGINT
);

CREATE TABLE staff_Game (
    id BIGINT PRIMARY KEY,
    staff_id BIGINT REFERENCES staff(id)
);

-- Team Game participation
CREATE TABLE Team_Game (
    id BIGINT PRIMARY KEY,
    match_id BIGINT REFERENCES Match(id),
    team_id BIGINT REFERENCES Team(id),
    is_host BOOLEAN,
    points SMALLINT
);

-- Role and tactical information
CREATE TABLE Role (
    id BIGINT PRIMARY KEY,
    position VARCHAR,
    tactic VARCHAR,
    start_timelight TIME,
    end_time TIME,
    time TIME,
    x_average FLOAT,
    y_average FLOAT,
    team_id BIGINT REFERENCES Team(id)
);

-- Action tracking tables
CREATE TABLE Action_Video (
    id BIGINT PRIMARY KEY,
    team_game_id BIGINT REFERENCES Team_Game(id),
    timestamp TIMESTAMP,
    position_x FLOAT,
    position_y FLOAT,
    type VARCHAR,
    minute INT,
    half SMALLINT
);

CREATE TABLE Action_Document (
    id BIGINT PRIMARY KEY,
    team_game_id BIGINT REFERENCES Team_Game(id),
    type VARCHAR,
    minute INT,
    half SMALLINT
);

CREATE TABLE Action_Document_S (
    id BIGINT PRIMARY KEY,
    type VARCHAR,
    minute INT,
    half SMALLINT
);

-- Specific action types (from piece 1 - kept as requested)
CREATE TABLE Pass (
    id BIGINT PRIMARY KEY,
    action_id BIGINT REFERENCES Action_Video(id),
    player_id BIGINT REFERENCES Player(id)
);

CREATE TABLE Shot (
    id BIGINT PRIMARY KEY,
    action_id BIGINT REFERENCES Action_Video(id),
    player_id BIGINT REFERENCES Player(id)
);

CREATE TABLE Fault (
    id BIGINT PRIMARY KEY,
    action_id BIGINT REFERENCES Action_Video(id),
    player_id BIGINT REFERENCES Player(id)
);

CREATE TABLE Interception (
    id BIGINT PRIMARY KEY,
    action_id BIGINT REFERENCES Action_Video(id),
    player_id BIGINT REFERENCES Player(id)
);

CREATE TABLE Duel (
    id BIGINT PRIMARY KEY,
    action_id BIGINT REFERENCES Action_Video(id),
    player_id BIGINT REFERENCES Player(id)
);

CREATE TABLE Clearance (
    id BIGINT PRIMARY KEY,
    action_id BIGINT REFERENCES Action_Video(id),
    player_id BIGINT REFERENCES Player(id)
);

-- Tracking and analytics
CREATE TABLE Tracking (
    id BIGINT PRIMARY KEY,
    team_game_id BIGINT REFERENCES Team_Game(id),
    new_column BIGINT
);

CREATE TABLE Ball_tracking (
    id BIGINT PRIMARY KEY
);

-- Medical and wellness management
CREATE TABLE Bodypart (
    id BIGINT PRIMARY KEY,
    name VARCHAR
);

CREATE TABLE Lesiones (
    id BIGINT PRIMARY KEY,
    player_id BIGINT REFERENCES Player(id),
    bodypart_id BIGINT REFERENCES Bodypart(id),
    surface VARCHAR,
    severity SMALLINT,
    type VARCHAR,
    date DATE,
    return_date DATE,
    expected_return_date DATE,
    training_date DATE,
    expected_training_date DATE,
    treatment VARCHAR,
    activity VARCHAR,
    comments TEXT
);

CREATE TABLE wellness_satisfaction_tests (
    id BIGINT PRIMARY KEY,
    player_id BIGINT REFERENCES Player(id),
    datetime DATE,
    morale SMALLINT,
    tiredness SMALLINT
);

CREATE TABLE Physical_tests (
    id BIGINT PRIMARY KEY,
    player_id BIGINT REFERENCES Player(id),
    FOREIGN KEY (id) REFERENCES wellness_satisfaction_tests(id)
);

-- Training management
CREATE TABLE training (
    id BIGINT PRIMARY KEY,
    team_id BIGINT REFERENCES Team(id),
    datetime DATE,
    type VARCHAR,
    location VARCHAR
);

CREATE TABLE training_exercise (
    id BIGINT PRIMARY KEY,
    training_id BIGINT REFERENCES training(id),
    exercise_id BIGINT, -- Note: Will need to reference specific action tables after you provide the action list
    "order" INT,
    type VARCHAR,
    FOREIGN KEY (training_id) REFERENCES training(id)
);

-- Additional foreign key constraints for proper relationships
ALTER TABLE staff_Game
ADD COLUMN match_id BIGINT,
ADD CONSTRAINT fk_staff_game_match
FOREIGN KEY (match_id) REFERENCES Match(id);

ALTER TABLE staff_team
ADD COLUMN staff_id BIGINT,
ADD COLUMN team_id BIGINT,
ADD CONSTRAINT fk_staff_team_staff
FOREIGN KEY (staff_id) REFERENCES staff(id),
ADD CONSTRAINT fk_staff_team_team
FOREIGN KEY (team_id) REFERENCES Team(id);