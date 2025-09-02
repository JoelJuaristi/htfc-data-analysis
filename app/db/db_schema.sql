-- NATION (referenced by player & staff)
CREATE TABLE nation (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(3) -- ISO country code (e.g., 'ESP', 'FRA')
);

-- COMPETITION
CREATE TABLE competition (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    season VARCHAR(20), -- e.g., '2024-25'
    competition_type VARCHAR(50), -- e.g., 'League', 'Cup', 'Friendly'
    country VARCHAR(100)
);

-- TEAM
CREATE TABLE team (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    short_name VARCHAR(50),
    founded_year INT,
    city VARCHAR(100),
    stadium VARCHAR(255)
);

-- MATCH
CREATE TABLE match (
    id SERIAL PRIMARY KEY,
    competition_id INT REFERENCES competition(id),
    match_date DATE NOT NULL,
    match_time TIME,
    venue VARCHAR(255),
    matchday INT, -- round/matchday number
    status VARCHAR(20) -- 'scheduled', 'ongoing', 'finished', 'postponed'
);

-- TEAM_GAME (link: team <-> match)
CREATE TABLE team_game (
    id SERIAL PRIMARY KEY,
    team_id INT NOT NULL REFERENCES team(id),
    match_id INT NOT NULL REFERENCES match(id),
    is_home BOOLEAN, -- true if home team, false if away
    final_score INT, -- goals scored by this team
    formation VARCHAR(20) -- e.g., '4-4-2', '3-5-2'
);

-- STAFF
CREATE TABLE staff (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    date_of_birth DATE,
    nation_id INT REFERENCES nation(id),
    role VARCHAR(100), -- e.g., 'Head Coach', 'Assistant Coach', 'Physiotherapist'
    license_level VARCHAR(50) -- coaching license level
);

-- PLAYER
CREATE TABLE player (
    id SERIAL PRIMARY KEY,
    team_id INT REFERENCES team(id),
    name VARCHAR(255) NOT NULL,
    date_of_birth DATE,
    nation_id INT REFERENCES nation(id),
    position VARCHAR(50), -- e.g., 'Goalkeeper', 'Defender', 'Midfielder', 'Forward'
    jersey_number INT,
    height_cm INT,
    weight_kg INT,
    preferred_foot VARCHAR(10), -- 'Left', 'Right', 'Both'
    contract_start DATE,
    contract_end DATE
);

-- ROLE (link: player <-> team_game)
CREATE TABLE role (
    id SERIAL PRIMARY KEY,
    player_id INT NOT NULL REFERENCES player(id),
    team_game_id INT NOT NULL REFERENCES team_game(id),
    is_starter BOOLEAN, -- true if in starting XI
    is_captain BOOLEAN,
    is_vice_captain BOOLEAN,
    minutes_played INT,
    position_played VARCHAR(50), -- position in this specific game
    jersey_number INT -- jersey number for this game (can change)
);

-- TRACKING (link: player <-> team_game)
CREATE TABLE tracking (
    id SERIAL PRIMARY KEY,
    player_id INT NOT NULL REFERENCES player(id),
    team_game_id INT NOT NULL REFERENCES team_game(id),
    total_distance_m DECIMAL(8,2), -- total distance covered in meters
    max_speed_kmh DECIMAL(5,2), -- maximum speed in km/h
    average_speed_kmh DECIMAL(5,2),
    high_intensity_distance_m DECIMAL(8,2), -- distance at high intensity
    sprints_count INT,
    accelerations_count INT,
    decelerations_count INT,
    heart_rate_avg INT,
    heart_rate_max INT
);

-- BALL TRACKING (link: match)
CREATE TABLE ball_tracking (
    id SERIAL PRIMARY KEY,
    match_id INT NOT NULL REFERENCES match(id),
    timestamp TIMESTAMP, -- exact moment of tracking
    x_coordinate DECIMAL(6,2), -- field position x
    y_coordinate DECIMAL(6,2), -- field position y
    z_coordinate DECIMAL(6,2), -- ball height
    velocity_x DECIMAL(6,2),
    velocity_y DECIMAL(6,2),
    velocity_z DECIMAL(6,2),
    ball_speed_kmh DECIMAL(6,2)
);

-- REFEREE
CREATE TABLE referee (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    date_of_birth DATE,
    nation_id INT REFERENCES nation(id),
    license_level VARCHAR(50)
);

-- REFEREE_GAME (link: referee <-> match)
CREATE TABLE referee_game (
    id SERIAL PRIMARY KEY,
    referee_id INT NOT NULL REFERENCES referee(id),
    match_id INT NOT NULL REFERENCES match(id),
    referee_type VARCHAR(50) -- 'Main', 'Assistant 1', 'Assistant 2', 'Fourth Official', 'VAR'
);

-- ACTION DOCUMENT / VIDEO (1 per team per game)
CREATE TABLE action_document (
    id SERIAL PRIMARY KEY,
    team_game_id INT NOT NULL REFERENCES team_game(id),
    file_path TEXT,
    document_type VARCHAR(50), -- e.g., 'match_report', 'tactical_analysis'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE action_video (
    id SERIAL PRIMARY KEY,
    team_game_id INT NOT NULL REFERENCES team_game(id),
    file_path TEXT,
    video_type VARCHAR(50), -- e.g., 'full_match', 'highlights', 'tactical_clips'
    duration_seconds INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ACTIONS (specialized tables)
CREATE TABLE pass (
    id SERIAL PRIMARY KEY,
    player_id INT NOT NULL REFERENCES player(id),
    action_document_id INT REFERENCES action_document(id),
    action_video_id INT REFERENCES action_video(id),
    match_minute INT,
    timestamp_seconds INT, -- seconds from match start
    pass_type VARCHAR(50), -- e.g., 'Short', 'Long', 'Cross', 'Through ball'
    start_x DECIMAL(6,2), -- starting position
    start_y DECIMAL(6,2),
    end_x DECIMAL(6,2), -- ending position
    end_y DECIMAL(6,2),
    distance_m DECIMAL(6,2),
    outcome VARCHAR(20), -- 'Complete', 'Incomplete', 'Intercepted'
    receiver_player_id INT REFERENCES player(id)
);

CREATE TABLE duel (
    id SERIAL PRIMARY KEY,
    player_id INT NOT NULL REFERENCES player(id),
    action_document_id INT REFERENCES action_document(id),
    action_video_id INT REFERENCES action_video(id),
    match_minute INT,
    timestamp_seconds INT,
    duel_type VARCHAR(50), -- e.g., 'Aerial', 'Ground', '1v1'
    outcome VARCHAR(20), -- 'Won', 'Lost'
    opponent_player_id INT REFERENCES player(id),
    x_coordinate DECIMAL(6,2),
    y_coordinate DECIMAL(6,2)
);

CREATE TABLE assist (
    id SERIAL PRIMARY KEY,
    player_id INT NOT NULL REFERENCES player(id),
    action_document_id INT REFERENCES action_document(id),
    action_video_id INT REFERENCES action_video(id),
    match_minute INT,
    timestamp_seconds INT,
    assist_type VARCHAR(50), -- e.g., 'Direct', 'Key pass', 'Cross', 'Set piece'
    goal_scorer_id INT REFERENCES player(id),
    x_coordinate DECIMAL(6,2),
    y_coordinate DECIMAL(6,2)
);

CREATE TABLE goal (
    id SERIAL PRIMARY KEY,
    player_id INT NOT NULL REFERENCES player(id),
    action_document_id INT REFERENCES action_document(id),
    action_video_id INT REFERENCES action_video(id),
    match_minute INT,
    timestamp_seconds INT,
    goal_type VARCHAR(50), -- e.g., 'Open play', 'Penalty', 'Free kick', 'Header', 'Own goal'
    body_part VARCHAR(20), -- 'Right foot', 'Left foot', 'Head', 'Chest'
    x_coordinate DECIMAL(6,2),
    y_coordinate DECIMAL(6,2),
    assisting_player_id INT REFERENCES player(id)
);

CREATE TABLE card (
    id SERIAL PRIMARY KEY,
    player_id INT NOT NULL REFERENCES player(id),
    card_type VARCHAR(20), -- 'Yellow', 'Red', 'Second Yellow'
    match_minute INT,
    timestamp_seconds INT,
    reason VARCHAR(255), -- reason for the card
    action_document_id INT REFERENCES action_document(id),
    action_video_id INT REFERENCES action_video(id)
);

CREATE TABLE freekick (
    id SERIAL PRIMARY KEY,
    player_id INT NOT NULL REFERENCES player(id),
    action_document_id INT REFERENCES action_document(id),
    action_video_id INT REFERENCES action_video(id),
    match_minute INT,
    timestamp_seconds INT,
    freekick_type VARCHAR(20), -- 'Direct', 'Indirect'
    outcome VARCHAR(30), -- e.g., 'Goal', 'On target', 'Off target', 'Blocked', 'Saved'
    x_coordinate DECIMAL(6,2),
    y_coordinate DECIMAL(6,2)
);

-- TRAINING + EXERCISES
CREATE TABLE training (
    id SERIAL PRIMARY KEY,
    team_id INT NOT NULL REFERENCES team(id),
    training_date DATE NOT NULL,
    training_type VARCHAR(50), -- e.g., 'Physical', 'Tactical', 'Technical', 'Recovery'
    duration_minutes INT,
    location VARCHAR(255)
);

CREATE TABLE training_exercise (
    id SERIAL PRIMARY KEY,
    training_id INT NOT NULL REFERENCES training(id),
    exercise_name VARCHAR(255) NOT NULL,
    exercise_type VARCHAR(50), -- e.g., 'Passing drill', 'Shooting practice', 'Fitness'
    duration_minutes INT,
    intensity VARCHAR(20), -- e.g., 'Low', 'Medium', 'High'
    description TEXT
);

-- WELLNESS & SATISFACTION TESTS
CREATE TABLE wellness_test (
    id SERIAL PRIMARY KEY,
    player_id INT NOT NULL REFERENCES player(id),
    test_date DATE NOT NULL,
    fatigue_score INT, -- scale 1-10
    stress_score INT, -- scale 1-10
    sleep_quality_score INT, -- scale 1-10
    muscle_soreness_score INT, -- scale 1-10
    mood_score INT, -- scale 1-10
    readiness_score INT, -- overall readiness scale 1-10
    comments TEXT
);

CREATE TABLE satisfaction_test (
    id SERIAL PRIMARY KEY,
    player_id INT NOT NULL REFERENCES player(id),
    test_date DATE NOT NULL,
    coach_relationship_score INT, -- scale 1-10
    team_atmosphere_score INT, -- scale 1-10
    playing_time_satisfaction INT, -- scale 1-10
    training_quality_score INT, -- scale 1-10
    overall_satisfaction INT, -- scale 1-10
    comments TEXT
);

-- PHYSICAL TEST
CREATE TABLE physical_test (
    id SERIAL PRIMARY KEY,
    player_id INT NOT NULL REFERENCES player(id),
    test_date DATE NOT NULL,
    test_type VARCHAR(50), -- e.g., 'VO2 Max', 'Sprint test', 'Agility', 'Strength'
    result_value DECIMAL(8,2),
    result_unit VARCHAR(20), -- e.g., 'ml/kg/min', 'seconds', 'kg'
    baseline_value DECIMAL(8,2), -- comparison baseline
    test_conditions TEXT -- weather, equipment used, etc.
);

-- INJURY + BODYPART
CREATE TABLE injury (
    id SERIAL PRIMARY KEY,
    player_id INT NOT NULL REFERENCES player(id),
    injury_date DATE NOT NULL,
    injury_type VARCHAR(100), -- e.g., 'Muscle strain', 'Ligament tear', 'Fracture'
    severity VARCHAR(20), -- e.g., 'Minor', 'Moderate', 'Severe'
    expected_recovery_days INT,
    actual_recovery_days INT,
    injury_context VARCHAR(255), -- how injury occurred
    return_date DATE,
    treatment_notes TEXT
);

CREATE TABLE bodypart (
    id SERIAL PRIMARY KEY,
    injury_id INT NOT NULL REFERENCES injury(id),
    body_part VARCHAR(50), -- e.g., 'Hamstring', 'Ankle', 'Knee', 'Shoulder'
    laterality VARCHAR(10), -- 'Left', 'Right', 'Both'
    specific_location VARCHAR(100) -- more detailed location if needed
);

-- STAFF TEAM (link: staff <-> team)
CREATE TABLE staff_team (
    id SERIAL PRIMARY KEY,
    staff_id INT NOT NULL REFERENCES staff(id),
    team_id INT NOT NULL REFERENCES team(id),
    start_date DATE,
    end_date DATE,
    is_active BOOLEAN DEFAULT true
);

-- STAFF GAME (link: staff <-> team_game)
CREATE TABLE staff_game (
    id SERIAL PRIMARY KEY,
    staff_id INT NOT NULL REFERENCES staff(id),
    team_game_id INT NOT NULL REFERENCES team_game(id),
    role_in_game VARCHAR(100) -- specific role for this game
);

-- ACTION DOCUMENT STAFF (link: staff <-> team_game)
CREATE TABLE action_document_staff (
    id SERIAL PRIMARY KEY,
    staff_id INT NOT NULL REFERENCES staff(id),
    team_game_id INT NOT NULL REFERENCES team_game(id),
    document_type VARCHAR(50), -- e.g., 'Match analysis', 'Player report'
    file_path TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);