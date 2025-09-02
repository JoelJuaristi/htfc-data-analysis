-- NATION (referenced by player & staff)
CREATE TABLE nation (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(3) -- ISO country code (e.g., 'ESP', 'FRA')
);

-- STADIUM (replaces field_dimensions and provides venue structure)
CREATE TABLE stadium (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    city VARCHAR(100),
    country VARCHAR(100),
    capacity INT,
    opened_year INT,
    surface_type VARCHAR(50), -- 'Natural grass', 'Artificial turf', 'Hybrid'
    length_m DECIMAL(6,2), -- field length in meters
    width_m DECIMAL(6,2), -- field width in meters
    coordinate_system VARCHAR(50), -- e.g., '0-100 normalized', 'meters from center'
    origin_description TEXT, -- where (0,0) is located for tracking data
    altitude_m INT, -- altitude above sea level
    has_roof BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100)
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
    home_stadium_id INT REFERENCES stadium(id) -- team's home stadium
);

-- MATCH
CREATE TABLE match (
    id SERIAL PRIMARY KEY,
    competition_id INT REFERENCES competition(id),
    stadium_id INT REFERENCES stadium(id),
    match_date DATE NOT NULL,
    match_time TIME,
    matchday INT, -- round/matchday number
    status VARCHAR(20), -- 'scheduled', 'ongoing', 'finished', 'postponed'
    attendance INT,
    weather VARCHAR(50), -- 'Sunny', 'Rainy', 'Cloudy', 'Snow'
    temperature_celsius INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100)
);

-- TEAM_GAME (link: team <-> match)
CREATE TABLE team_game (
    id SERIAL PRIMARY KEY,
    team_id INT NOT NULL REFERENCES team(id),
    match_id INT NOT NULL REFERENCES match(id),
    is_home BOOLEAN, -- true if home team, false if away
    final_score INT, -- goals scored by this team
    formation VARCHAR(20), -- e.g., '4-4-2', '3-5-2'
    possession_percentage DECIMAL(5,2),
    shots INT,
    shots_on_target INT,
    corners INT,
    fouls INT,
    yellow_cards INT,
    red_cards INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100),
    CONSTRAINT unique_team_match UNIQUE(team_id, match_id)
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
    contract_end DATE,
    market_value_euros BIGINT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100)
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
    jersey_number INT, -- jersey number for this game (can change)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100),
    CONSTRAINT unique_player_team_game UNIQUE(player_id, team_game_id)
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

-- SUBSTITUTIONS (to track player substitutions properly)
CREATE TABLE substitution (
    id SERIAL PRIMARY KEY,
    match_id INT NOT NULL REFERENCES match(id),
    team_game_id INT NOT NULL REFERENCES team_game(id),
    player_out_id INT NOT NULL REFERENCES player(id),
    player_in_id INT NOT NULL REFERENCES player(id),
    minute INT NOT NULL,
    reason VARCHAR(50), -- e.g., 'Tactical', 'Injury', 'Disciplinary'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100)
);

-- ESSENTIAL INDEXES FOR PERFORMANCE
CREATE INDEX idx_match_date ON match(match_date);
CREATE INDEX idx_match_stadium ON match(stadium_id);
CREATE INDEX idx_team_home_stadium ON team(home_stadium_id);
CREATE INDEX idx_player_team ON player(team_id);
CREATE INDEX idx_player_nation ON player(nation_id);
CREATE INDEX idx_team_game_match ON team_game(match_id);
CREATE INDEX idx_team_game_team ON team_game(team_id);
CREATE INDEX idx_role_player ON role(player_id);
CREATE INDEX idx_role_team_game ON role(team_game_id);
CREATE INDEX idx_tracking_player ON tracking(player_id);
CREATE INDEX idx_tracking_team_game ON tracking(team_game_id);

-- Action table indexes
CREATE INDEX idx_pass_player ON pass(player_id);
CREATE INDEX idx_pass_minute ON pass(match_minute);
CREATE INDEX idx_goal_player ON goal(player_id);
CREATE INDEX idx_goal_minute ON goal(match_minute);
CREATE INDEX idx_assist_player ON assist(player_id);
CREATE INDEX idx_duel_player ON duel(player_id);
CREATE INDEX idx_card_player ON card(player_id);
CREATE INDEX idx_freekick_player ON freekick(player_id);

-- Staff and referee indexes
CREATE INDEX idx_staff_nation ON staff(nation_id);
CREATE INDEX idx_referee_nation ON referee(nation_id);
CREATE INDEX idx_staff_team_staff ON staff_team(staff_id);
CREATE INDEX idx_staff_team_team ON staff_team(team_id);
CREATE INDEX idx_referee_game_match ON referee_game(match_id);

-- Training and test indexes
CREATE INDEX idx_training_team ON training(team_id);
CREATE INDEX idx_training_date ON training(training_date);
CREATE INDEX idx_wellness_test_player ON wellness_test(player_id);
CREATE INDEX idx_wellness_test_date ON wellness_test(test_date);
CREATE INDEX idx_satisfaction_test_player ON satisfaction_test(player_id);
CREATE INDEX idx_physical_test_player ON physical_test(player_id);
CREATE INDEX idx_injury_player ON injury(player_id);
CREATE INDEX idx_injury_date ON injury(injury_date);