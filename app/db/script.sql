-- Sample Data for Football Analytics Database
-- This script populates all tables with realistic example data

-- Nations
INSERT INTO "Nation" (name, code) VALUES
('Spain', 'ESP'),
('England', 'ENG'),
('Brazil', 'BRA'),
('Argentina', 'ARG'),
('Germany', 'GER'),
('France', 'FRA'),
('Portugal', 'POR'),
('Netherlands', 'NED'),
('Italy', 'ITA'),
('Belgium', 'BEL');

-- Stadiums
INSERT INTO "Stadium" (name, city, capacity, surface_type, length_m, width_m, coordinate_system, altitude_m, has_roof) VALUES
('Camp Nou', 'Barcelona', 99354, 'Natural Grass', 105.00, 68.00, 'WGS84', 12, false),
('Santiago Bernabéu', 'Madrid', 81044, 'Natural Grass', 105.00, 68.00, 'WGS84', 650, true),
('Wanda Metropolitano', 'Madrid', 68456, 'Natural Grass', 105.00, 68.00, 'WGS84', 650, false),
('Mestalla', 'Valencia', 49430, 'Natural Grass', 105.00, 68.00, 'WGS84', 11, false),
('Ramón Sánchez-Pizjuán', 'Seville', 43883, 'Natural Grass', 105.00, 68.00, 'WGS84', 12, false);

-- Competitions
INSERT INTO "Competition" (name, season, competition_type, nation_id, category) VALUES
('La Liga', '2024/2025', 'League', 1, 'First Division'),
('Copa del Rey', '2024/2025', 'Cup', 1, 'Domestic Cup'),
('UEFA Champions League', '2024/2025', 'International', NULL, 'European Cup');

-- Legs
INSERT INTO "Leg" (name, extra_time, "group") VALUES
('Matchday 1', false, NULL),
('Matchday 2', false, NULL),
('Round of 16 - First Leg', false, NULL),
('Round of 16 - Second Leg', true, NULL),
('Quarterfinals', false, NULL);

-- Teams
INSERT INTO "Team" (name, short_name, founded_year, city, home_stadium_id) VALUES
('FC Barcelona', 'Barça', 1899, 'Barcelona', 1),
('Real Madrid CF', 'Madrid', 1902, 'Madrid', 2),
('Atlético Madrid', 'Atleti', 1903, 'Madrid', 3),
('Valencia CF', 'Valencia', 1919, 'Valencia', 4),
('Sevilla FC', 'Sevilla', 1890, 'Seville', 5);

-- Matches
INSERT INTO "Match" (competition_id, stadium_id, leg_id, match_date, match_time, matchday, attendance, weather, temperature_celsius, video_URL) VALUES
(1, 1, 1, '2024-09-15', '21:00:00', 1, 85234, 'Clear', 24, 'https://example.com/match1'),
(1, 2, 1, '2024-09-15', '19:00:00', 1, 78456, 'Partly Cloudy', 22, 'https://example.com/match2'),
(1, 3, 2, '2024-09-22', '21:00:00', 2, 65123, 'Clear', 20, 'https://example.com/match3'),
(2, 4, 3, '2024-10-05', '20:00:00', NULL, 42000, 'Rainy', 18, 'https://example.com/match4'),
(3, 1, 4, '2024-10-20', '21:00:00', NULL, 95000, 'Clear', 21, 'https://example.com/match5');

-- Staff
INSERT INTO "Staff" (name, date_of_birth, nation_id, role, license_level) VALUES
('Xavi Hernández', '1980-01-25', 1, 'Head Coach', 'UEFA Pro'),
('Carlo Ancelotti', '1959-06-10', 9, 'Head Coach', 'UEFA Pro'),
('Diego Simeone', '1970-04-28', 4, 'Head Coach', 'UEFA Pro'),
('Luis García', '1975-05-12', 1, 'Assistant Coach', 'UEFA A'),
('Antonio Pintus', '1968-09-03', 9, 'Fitness Coach', 'UEFA B'),
('Dr. Carlos Ramírez', '1972-11-20', 1, 'Team Doctor', 'Medical License'),
('José Morales', '1985-03-15', 1, 'Video Analyst', NULL),
('Pedro Sánchez', '1978-07-08', 1, 'Goalkeeping Coach', 'UEFA B');

-- Players for FC Barcelona
INSERT INTO "Player" (team_id, name, date_of_birth, nation_id, position, jersey_number, height_cm, weight_kg, preferred_foot, contract_start, contract_end, market_value_euros, is_active) VALUES
(1, 'Marc-André ter Stegen', '1992-04-30', 5, 'Goalkeeper', 1, 187, 85, 'Right', '2014-07-01', '2026-06-30', 60000000, true),
(1, 'Ronald Araújo', '1999-03-07', 4, 'Defender', 4, 188, 84, 'Right', '2020-01-01', '2026-06-30', 70000000, true),
(1, 'Jules Koundé', '1998-11-12', 6, 'Defender', 23, 180, 75, 'Right', '2022-07-28', '2027-06-30', 60000000, true),
(1, 'Alejandro Balde', '2003-10-18', 1, 'Defender', 3, 175, 70, 'Left', '2022-09-01', '2028-06-30', 35000000, true),
(1, 'Pedri González', '2002-11-25', 1, 'Midfielder', 8, 174, 60, 'Right', '2020-09-02', '2026-06-30', 100000000, true),
(1, 'Frenkie de Jong', '1997-05-12', 8, 'Midfielder', 21, 180, 74, 'Right', '2019-07-01', '2026-06-30', 80000000, true),
(1, 'Gavi', '2004-08-05', 1, 'Midfielder', 6, 173, 69, 'Right', '2021-10-06', '2026-06-30', 90000000, true),
(1, 'Robert Lewandowski', '1988-08-21', 7, 'Forward', 9, 185, 81, 'Right', '2022-07-19', '2026-06-30', 45000000, true),
(1, 'Raphinha', '1996-12-14', 3, 'Forward', 11, 176, 68, 'Left', '2022-07-13', '2027-06-30', 60000000, true),
(1, 'Ferran Torres', '2000-02-29', 1, 'Forward', 7, 184, 77, 'Right', '2022-01-03', '2027-06-30', 55000000, true),
(1, 'Iñigo Martínez', '1991-05-17', 1, 'Defender', 5, 182, 79, 'Left', '2023-07-01', '2025-06-30', 15000000, true);

-- Players for Real Madrid
INSERT INTO "Player" (team_id, name, date_of_birth, nation_id, position, jersey_number, height_cm, weight_kg, preferred_foot, contract_start, contract_end, market_value_euros, is_active) VALUES
(2, 'Thibaut Courtois', '1992-05-11', 10, 'Goalkeeper', 1, 199, 96, 'Left', '2018-08-09', '2026-06-30', 60000000, true),
(2, 'Dani Carvajal', '1992-01-11', 1, 'Defender', 2, 173, 73, 'Right', '2013-07-01', '2025-06-30', 20000000, true),
(2, 'Antonio Rüdiger', '1993-03-03', 5, 'Defender', 22, 190, 85, 'Right', '2022-06-02', '2026-06-30', 45000000, true),
(2, 'Ferland Mendy', '1995-06-08', 6, 'Defender', 23, 180, 73, 'Left', '2019-06-12', '2025-06-30', 35000000, true),
(2, 'Federico Valverde', '1998-07-22', 4, 'Midfielder', 15, 182, 78, 'Right', '2016-07-21', '2027-06-30', 120000000, true),
(2, 'Luka Modrić', '1985-09-09', 4, 'Midfielder', 10, 172, 66, 'Right', '2012-08-27', '2025-06-30', 10000000, true),
(2, 'Jude Bellingham', '2003-06-29', 2, 'Midfielder', 5, 186, 75, 'Right', '2023-06-14', '2029-06-30', 180000000, true),
(2, 'Vinícius Júnior', '2000-07-12', 3, 'Forward', 7, 176, 73, 'Right', '2018-07-23', '2027-06-30', 150000000, true),
(2, 'Rodrygo', '2001-01-09', 3, 'Forward', 11, 174, 64, 'Right', '2019-06-15', '2028-06-30', 100000000, true),
(2, 'Joselu', '1990-03-27', 1, 'Forward', 14, 192, 85, 'Right', '2023-07-01', '2025-06-30', 8000000, true);

-- Players for Atlético Madrid
INSERT INTO "Player" (team_id, name, date_of_birth, nation_id, position, jersey_number, height_cm, weight_kg, preferred_foot, contract_start, contract_end, market_value_euros, is_active) VALUES
(3, 'Jan Oblak', '1993-01-07', 1, 'Goalkeeper', 13, 188, 87, 'Right', '2014-07-16', '2028-06-30', 50000000, true),
(3, 'José María Giménez', '1995-01-20', 4, 'Defender', 2, 185, 80, 'Right', '2013-08-31', '2025-06-30', 40000000, true),
(3, 'Stefan Savić', '1991-01-08', 1, 'Defender', 15, 187, 82, 'Right', '2015-08-05', '2025-06-30', 15000000, true),
(3, 'Marcos Llorente', '1995-01-30', 1, 'Midfielder', 14, 184, 74, 'Right', '2019-07-01', '2027-06-30', 50000000, true),
(3, 'Koke', '1992-01-08', 1, 'Midfielder', 6, 176, 74, 'Right', '2009-07-01', '2024-06-30', 20000000, true),
(3, 'Antoine Griezmann', '1991-03-21', 6, 'Forward', 7, 176, 73, 'Left', '2014-07-28', '2026-06-30', 30000000, true),
(3, 'Álvaro Morata', '1992-10-23', 1, 'Forward', 19, 190, 84, 'Right', '2022-08-11', '2025-06-30', 25000000, true);

-- Team_Game records
INSERT INTO "Team_Game" (team_id, match_id, is_home, final_score, goals_scored, goals_conceded) VALUES
(1, 1, true, '2-1', 2, 1),
(4, 1, false, '1-2', 1, 2),
(2, 2, true, '3-0', 3, 0),
(5, 2, false, '0-3', 0, 3),
(3, 3, true, '1-1', 1, 1),
(1, 3, false, '1-1', 1, 1),
(4, 4, true, '2-2', 2, 2),
(3, 4, false, '2-2', 2, 2),
(1, 5, true, '4-2', 4, 2),
(2, 5, false, '2-4', 2, 4);

-- Staff_Team assignments
INSERT INTO "Staff_Team" (staff_id, team_id, start_date, end_date, is_active) VALUES
(1, 1, '2023-07-01', NULL, true),
(2, 2, '2021-06-01', NULL, true),
(3, 3, '2011-12-23', NULL, true),
(4, 1, '2023-07-01', NULL, true),
(5, 2, '2019-06-01', NULL, true),
(6, 1, '2020-01-01', NULL, true),
(7, 1, '2022-01-01', NULL, true),
(8, 2, '2021-06-01', NULL, true);

-- Staff_Game assignments
INSERT INTO "Staff_Game" (staff_id, team_game_id, role) VALUES
(1, 1, 'Head Coach'),
(4, 1, 'Assistant Coach'),
(6, 1, 'Team Doctor'),
(2, 3, 'Head Coach'),
(5, 3, 'Fitness Coach'),
(3, 5, 'Head Coach');

-- Role records (player participation in matches)
INSERT INTO "Role" (player_id, team_game_id, is_captain, is_vice_captain, minute_started, minute_finished, position_played, jersey_number) VALUES
-- Barcelona vs Valencia (Match 1, Team_Game 1)
(1, 1, false, false, 0, 90, 'Goalkeeper', 1),
(2, 1, true, false, 0, 90, 'Center Back', 4),
(3, 1, false, true, 0, 90, 'Center Back', 23),
(4, 1, false, false, 0, 85, 'Left Back', 3),
(5, 1, false, false, 0, 90, 'Central Midfielder', 8),
(6, 1, false, false, 0, 75, 'Central Midfielder', 21),
(7, 1, false, false, 0, 90, 'Central Midfielder', 6),
(8, 1, false, false, 0, 80, 'Striker', 9),
(9, 1, false, false, 0, 75, 'Right Winger', 11),
(10, 1, false, false, 0, 90, 'Left Winger', 7),
(11, 1, false, false, 75, 90, 'Central Midfielder', 5),
-- Real Madrid vs Sevilla (Match 2, Team_Game 3)
(12, 3, false, false, 0, 90, 'Goalkeeper', 1),
(13, 3, false, true, 0, 90, 'Right Back', 2),
(14, 3, true, false, 0, 90, 'Center Back', 22),
(15, 3, false, false, 0, 90, 'Left Back', 23),
(16, 3, false, false, 0, 90, 'Central Midfielder', 15),
(17, 3, false, false, 0, 70, 'Central Midfielder', 10),
(18, 3, false, false, 0, 90, 'Attacking Midfielder', 5),
(19, 3, false, false, 0, 90, 'Left Winger', 7),
(20, 3, false, false, 0, 85, 'Right Winger', 11),
(21, 3, false, false, 0, 70, 'Striker', 14);

-- Referees
INSERT INTO "Referee" (name, date_of_birth, nation_id, license_level) VALUES
('Antonio Mateu Lahoz', '1977-03-12', 1, 'FIFA International'),
('José María Sánchez Martínez', '1983-09-26', 1, 'FIFA International'),
('Juan Martínez Munuera', '1982-03-04', 1, 'Primera División'),
('Carlos Del Cerro Grande', '1976-03-13', 1, 'FIFA International'),
('Ricardo De Burgos Bengoetxea', '1981-06-17', 1, 'Primera División');

-- Referee_Game assignments
INSERT INTO "Referee_Game" (referee_id, match_id, referee_type) VALUES
(1, 1, 'Main Referee'),
(2, 1, 'Assistant Referee 1'),
(3, 1, 'Assistant Referee 2'),
(4, 2, 'Main Referee'),
(5, 2, 'VAR'),
(1, 3, 'Main Referee'),
(2, 4, 'Main Referee'),
(3, 5, 'Main Referee');

-- Goals
INSERT INTO "Goal" (player_id, action_document_id, action_video_id, match_minute, timestamp_seconds, goal_type, body_part, x_coordinate, y_coordinate, assisting_player_id) VALUES
(8, NULL, NULL, 23, 1380, 'Open Play', 'Head', 98.50, 34.00, 10),
(10, NULL, NULL, 67, 4020, 'Open Play', 'Right Foot', 102.00, 38.00, 5),
(19, NULL, NULL, 15, 900, 'Open Play', 'Right Foot', 99.00, 30.00, 18),
(18, NULL, NULL, 42, 2520, 'Penalty', 'Right Foot', 105.00, 34.00, NULL),
(20, NULL, NULL, 78, 4680, 'Counter Attack', 'Left Foot', 100.50, 40.00, 16);

-- Assists
INSERT INTO "Assist" (player_id, action_document_id, action_video_id, match_minute, timestamp_seconds, assist_type, goal_scorer_id, goal_id, x_coordinate, y_coordinate) VALUES
(10, NULL, NULL, 23, 1378, 'Cross', 8, 1, 85.00, 5.00),
(5, NULL, NULL, 67, 4018, 'Through Ball', 10, 2, 75.00, 34.00),
(18, NULL, NULL, 15, 898, 'Through Ball', 19, 3, 70.00, 34.00),
(16, NULL, NULL, 78, 4678, 'Long Ball', 20, 5, 55.00, 30.00);

-- Passes (sample data)
INSERT INTO "Pass" (player_id, action_document_id, action_video_id, match_minute, timestamp_seconds, pass_type, start_x, start_y, end_x, end_y, distance_m, outcome, receiver_player_id) VALUES
(5, NULL, NULL, 10, 600, 'Short', 52.50, 34.00, 60.00, 30.00, 8.50, 'Complete', 7),
(6, NULL, NULL, 12, 720, 'Long', 45.00, 40.00, 85.00, 25.00, 45.00, 'Complete', 9),
(7, NULL, NULL, 15, 900, 'Through', 70.00, 34.00, 95.00, 34.00, 25.00, 'Complete', 8),
(5, NULL, NULL, 25, 1500, 'Cross', 75.00, 10.00, 100.00, 34.00, 30.00, 'Incomplete', NULL),
(18, NULL, NULL, 20, 1200, 'Short', 55.00, 34.00, 62.00, 30.00, 8.00, 'Complete', 17),
(16, NULL, NULL, 30, 1800, 'Long', 60.00, 34.00, 95.00, 20.00, 40.00, 'Complete', 19);

-- Duels
INSERT INTO "Duel" (player_id, action_document_id, action_video_id, match_minute, timestamp_seconds, duel_type, outcome, opponent_player_id, x_coordinate, y_coordinate) VALUES
(2, NULL, NULL, 18, 1080, 'Aerial', 'Won', NULL, 85.00, 34.00),
(3, NULL, NULL, 35, 2100, 'Ground', 'Won', NULL, 75.00, 40.00),
(4, NULL, NULL, 52, 3120, 'Tackle', 'Won', NULL, 30.00, 15.00),
(14, NULL, NULL, 25, 1500, 'Aerial', 'Won', NULL, 80.00, 34.00),
(15, NULL, NULL, 40, 2400, 'Ground', 'Lost', NULL, 25.00, 20.00);

-- Cards
INSERT INTO "Card" (player_id, card_type, match_minute, timestamp_seconds, reason, action_document_id, action_video_id) VALUES
(6, 'Yellow', 38, 2280, 'Tactical Foul', NULL, NULL),
(2, 'Yellow', 72, 4320, 'Simulation', NULL, NULL),
(17, 'Yellow', 55, 3300, 'Dissent', NULL, NULL),
(15, 'Yellow', 88, 5280, 'Time Wasting', NULL, NULL);

-- Freekicks
INSERT INTO "Freekick" (player_id, action_document_id, action_video_id, match_minute, timestamp_seconds, freekick_type, outcome, x_coordinate, y_coordinate) VALUES
(8, NULL, NULL, 28, 1680, 'Direct', 'Saved', 88.00, 34.00),
(18, NULL, NULL, 35, 2100, 'Direct', 'Goal', 90.00, 30.00),
(10, NULL, NULL, 65, 3900, 'Indirect', 'Off Target', 85.00, 40.00);

-- Substitutions
INSERT INTO "Substitution" (match_id, team_game_id, player_out_id, player_in_id, minute, reason) VALUES
(1, 1, 6, 11, 75, 'Tactical'),
(1, 1, 9, 11, 75, 'Tactical'),
(1, 1, 8, 11, 80, 'Fatigue'),
(2, 3, 17, 21, 70, 'Tactical'),
(2, 3, 21, 20, 70, 'Tactical');

-- Training sessions
INSERT INTO "Training" (team_id, training_date, training_type, duration_minutes, location) VALUES
(1, '2024-09-10', 'Tactical', 90, 'Ciutat Esportiva Joan Gamper'),
(1, '2024-09-11', 'Technical', 75, 'Ciutat Esportiva Joan Gamper'),
(1, '2024-09-12', 'Physical', 60, 'Ciutat Esportiva Joan Gamper'),
(2, '2024-09-10', 'Tactical', 90, 'Ciudad Deportiva Valdebebas'),
(2, '2024-09-11', 'Recovery', 45, 'Ciudad Deportiva Valdebebas');

-- Training exercises
INSERT INTO "Training_Exercise" (training_id, exercise_name, exercise_type, duration_minutes, intensity, description) VALUES
(1, 'Positional Play 8v8', 'Tactical', 30, 'Medium', 'Maintain possession in reduced space with positional constraints'),
(1, 'Pressing Drills', 'Tactical', 25, 'High', 'High intensity pressing in different zones'),
(2, 'Passing Combinations', 'Technical', 30, 'Medium', 'Short and long passing sequences'),
(2, 'Finishing Drills', 'Technical', 20, 'High', 'Shooting from various positions'),
(3, 'Interval Running', 'Physical', 25, 'High', 'High intensity interval training'),
(3, 'Core Strengthening', 'Physical', 20, 'Medium', 'Core stability exercises');

-- Wellness Tests
INSERT INTO "Wellness_Test" (player_id, test_date, fatigue_score, stress_score, sleep_quality_score, muscle_soreness_score, mood_score, readiness_score, comments) VALUES
(1, '2024-09-10', 3, 2, 4, 2, 4, 4, 'Feeling good, ready for match'),
(5, '2024-09-10', 4, 3, 3, 3, 3, 3, 'Slight fatigue but manageable'),
(8, '2024-09-10', 2, 1, 5, 1, 5, 5, 'Excellent condition'),
(12, '2024-09-10', 3, 2, 4, 2, 4, 4, 'Good recovery from last match'),
(18, '2024-09-10', 2, 2, 5, 1, 5, 5, 'Very good condition');

-- Satisfaction Tests
INSERT INTO "Satisfaction_Test" (player_id, test_date, coach_relationship_score, team_atmosphere_score, playing_time_satisfaction, training_quality_score, overall_satisfaction, comments) VALUES
(5, '2024-09-01', 5, 5, 5, 5, 5, 'Very happy with current situation'),
(6, '2024-09-01', 4, 5, 3, 4, 4, 'Would like more playing time'),
(10, '2024-09-01', 5, 4, 4, 5, 4, 'Good environment overall');

-- Physical Tests
INSERT INTO "Physical_Test" (player_id, test_date, test_type, result_value, result_unit, baseline_value, test_conditions) VALUES
(5, '2024-08-15', 'VO2 Max', 62.50, 'ml/kg/min', 60.00, 'Laboratory test, fasted state'),
(8, '2024-08-15', 'Sprint 30m', 3.85, 'seconds', 3.90, 'Outdoor track, optimal conditions'),
(18, '2024-08-15', 'Vertical Jump', 68.00, 'cm', 65.00, 'Indoor facility'),
(2, '2024-08-15', 'Yo-Yo Test', 2480.00, 'meters', 2400.00, 'Training ground');

-- Injuries
INSERT INTO "Injury" (player_id, injury_date, injury_type, severity, expected_recovery_days, actual_recovery_days, injury_context, return_date, treatment_notes) VALUES
(6, '2024-08-20', 'Muscle Strain', 'Minor', 14, 12, 'Training session', '2024-09-01', 'Physiotherapy and gradual return to training'),
(9, '2024-09-05', 'Ankle Sprain', 'Moderate', 21, NULL, 'Match injury', NULL, 'Ice, compression, rehabilitation exercises ongoing'),
(17, '2024-07-10', 'Hamstring Tear', 'Severe', 60, 58, 'Pre-season friendly', '2024-09-06', 'Surgery not required, intensive rehabilitation');

-- Body parts for injuries
INSERT INTO "Bodypart" (injury_id, body_part, type) VALUES
(1, 'Thigh', 'Quadriceps'),
(2, 'Ankle', 'Ligament'),
(3, 'Thigh', 'Hamstring');

-- Action Documents
INSERT INTO "Action_Document" (team_game_id, file_path, document_type, timestamp) VALUES
(1, '/documents/match1_barcelona_tactical_report.pdf', 'Tactical Report', 1726441200),
(1, '/documents/match1_barcelona_stats.pdf', 'Match Statistics', 1726441200),
(3, '/documents/match2_realmadrid_tactical_report.pdf', 'Tactical Report', 1726441200),
(3, '/documents/match2_realmadrid_performance.pdf', 'Performance Analysis', 1726441200);

-- Action Videos
INSERT INTO "Action_Video" (team_game_id, file_path, video_type, duration_seconds, timestamp) VALUES
(1, '/videos/match1_barcelona_highlights.mp4', 'Highlights', 420, 1726441200),
(1, '/videos/match1_barcelona_fullmatch.mp4', 'Full Match', 5400, 1726441200),
(3, '/videos/match2_realmadrid_highlights.mp4', 'Highlights', 380, 1726441200),
(3, '/videos/match2_realmadrid_tactical.mp4', 'Tactical Analysis', 900, 1726441200);

-- Action Documents for Staff
INSERT INTO "Action_Document_Staff" (staff_id, team_game_id, document_type, file_path, timestamp) VALUES
(1, 1, 'Pre-Match Report', '/staff_docs/xavi_prematch_match1.pdf', 1726354800),
(1, 1, 'Post-Match Analysis', '/staff_docs/xavi_postmatch_match1.pdf', 1726527600),
(2, 3, 'Pre-Match Report', '/staff_docs/ancelotti_prematch_match2.pdf', 1726354800),
(2, 3, 'Post-Match Analysis', '/staff_docs/ancelotti_postmatch_match2.pdf', 1726527600),
(3, 5, 'Pre-Match Report', '/staff_docs/simeone_prematch_match3.pdf', 1726354800);

-- Tracking data (player tracking paths)
INSERT INTO "Tracking" (player_id, team_game_id, raw_data_path) VALUES
(1, 1, '/tracking/match1_player1_terstegen.json'),
(2, 1, '/tracking/match1_player2_araujo.json'),
(3, 1, '/tracking/match1_player3_kounde.json'),
(4, 1, '/tracking/match1_player4_balde.json'),
(5, 1, '/tracking/match1_player5_pedri.json'),
(6, 1, '/tracking/match1_player6_dejong.json'),
(7, 1, '/tracking/match1_player7_gavi.json'),
(8, 1, '/tracking/match1_player8_lewandowski.json'),
(9, 1, '/tracking/match1_player9_raphinha.json'),
(10, 1, '/tracking/match1_player10_ferran.json'),
(12, 3, '/tracking/match2_player12_courtois.json'),
(13, 3, '/tracking/match2_player13_carvajal.json'),
(14, 3, '/tracking/match2_player14_rudiger.json'),
(15, 3, '/tracking/match2_player15_mendy.json'),
(16, 3, '/tracking/match2_player16_valverde.json'),
(17, 3, '/tracking/match2_player17_modric.json'),
(18, 3, '/tracking/match2_player18_bellingham.json'),
(19, 3, '/tracking/match2_player19_vinicius.json'),
(20, 3, '/tracking/match2_player20_rodrygo.json'),
(21, 3, '/tracking/match2_player21_joselu.json');

-- Ball Tracking data
INSERT INTO "Ball_Tracking" (match_id, raw_data_path) VALUES
(1, '/ball_tracking/match1_ball_tracking.json'),
(2, '/ball_tracking/match2_ball_tracking.json'),
(3, '/ball_tracking/match3_ball_tracking.json'),
(4, '/ball_tracking/match4_ball_tracking.json'),
(5, '/ball_tracking/match5_ball_tracking.json');

-- Additional passes for more comprehensive data
INSERT INTO "Pass" (player_id, action_document_id, action_video_id, match_minute, timestamp_seconds, pass_type, start_x, start_y, end_x, end_y, distance_m, outcome, receiver_player_id) VALUES
-- Barcelona vs Valencia
(5, NULL, NULL, 5, 300, 'Short', 50.00, 34.00, 55.00, 38.00, 6.40, 'Complete', 6),
(7, NULL, NULL, 8, 480, 'Short', 60.00, 30.00, 65.00, 25.00, 7.07, 'Complete', 10),
(6, NULL, NULL, 14, 840, 'Long', 40.00, 40.00, 80.00, 15.00, 48.16, 'Complete', 9),
(10, NULL, NULL, 18, 1080, 'Cross', 90.00, 8.00, 100.00, 34.00, 27.20, 'Complete', 8),
(4, NULL, NULL, 22, 1320, 'Through', 55.00, 15.00, 75.00, 20.00, 20.62, 'Complete', 10),
(5, NULL, NULL, 28, 1680, 'Short', 65.00, 34.00, 70.00, 30.00, 6.40, 'Complete', 7),
(7, NULL, NULL, 32, 1920, 'Long', 55.00, 25.00, 85.00, 40.00, 36.06, 'Incomplete', NULL),
(8, NULL, NULL, 38, 2280, 'Lay-off', 95.00, 34.00, 85.00, 38.00, 10.77, 'Complete', 5),
(6, NULL, NULL, 45, 2700, 'Short', 52.00, 34.00, 58.00, 34.00, 6.00, 'Complete', 5),
(5, NULL, NULL, 50, 3000, 'Through', 70.00, 34.00, 90.00, 30.00, 20.40, 'Complete', 10),
(10, NULL, NULL, 55, 3300, 'Cross', 88.00, 10.00, 98.00, 34.00, 25.30, 'Incomplete', NULL),
(7, NULL, NULL, 62, 3720, 'Short', 65.00, 34.00, 68.00, 30.00, 5.00, 'Complete', 8),
(5, NULL, NULL, 66, 3960, 'Through', 75.00, 34.00, 95.00, 38.00, 20.40, 'Complete', 10),
(4, NULL, NULL, 72, 4320, 'Long', 25.00, 20.00, 70.00, 40.00, 52.20, 'Complete', 9),
(6, NULL, NULL, 78, 4680, 'Short', 48.00, 34.00, 52.00, 38.00, 5.66, 'Complete', 7),
(11, NULL, NULL, 82, 4920, 'Short', 55.00, 34.00, 60.00, 30.00, 6.40, 'Complete', 5),
(5, NULL, NULL, 88, 5280, 'Long', 60.00, 34.00, 30.00, 40.00, 31.62, 'Complete', 4),
-- Real Madrid vs Sevilla
(16, NULL, NULL, 8, 480, 'Short', 55.00, 34.00, 62.00, 30.00, 8.06, 'Complete', 18),
(18, NULL, NULL, 12, 720, 'Through', 70.00, 34.00, 90.00, 30.00, 20.40, 'Complete', 19),
(17, NULL, NULL, 14, 840, 'Short', 50.00, 34.00, 56.00, 38.00, 7.21, 'Complete', 16),
(19, NULL, NULL, 18, 1080, 'Cross', 95.00, 10.00, 102.00, 34.00, 25.00, 'Incomplete', NULL),
(16, NULL, NULL, 22, 1320, 'Long', 45.00, 34.00, 85.00, 20.00, 43.86, 'Complete', 20),
(18, NULL, NULL, 28, 1680, 'Short', 68.00, 34.00, 74.00, 30.00, 7.21, 'Complete', 16),
(17, NULL, NULL, 32, 1920, 'Through', 65.00, 34.00, 82.00, 34.00, 17.00, 'Complete', 18),
(18, NULL, NULL, 38, 2280, 'Short', 75.00, 34.00, 80.00, 30.00, 6.40, 'Complete', 19),
(16, NULL, NULL, 45, 2700, 'Long', 55.00, 34.00, 90.00, 15.00, 40.31, 'Complete', 20),
(19, NULL, NULL, 52, 3120, 'Cross', 92.00, 8.00, 100.00, 34.00, 27.20, 'Complete', 21),
(18, NULL, NULL, 58, 3480, 'Through', 72.00, 34.00, 92.00, 30.00, 20.40, 'Complete', 19),
(16, NULL, NULL, 65, 3900, 'Short', 60.00, 34.00, 66.00, 30.00, 7.21, 'Complete', 17),
(17, NULL, NULL, 68, 4080, 'Long', 48.00, 40.00, 88.00, 20.00, 44.72, 'Complete', 20),
(20, NULL, NULL, 75, 4500, 'Cross', 90.00, 12.00, 98.00, 34.00, 23.32, 'Complete', 21),
(16, NULL, NULL, 82, 4920, 'Short', 58.00, 34.00, 64.00, 30.00, 7.21, 'Complete', 18),
(18, NULL, NULL, 86, 5160, 'Through', 68.00, 34.00, 85.00, 38.00, 17.46, 'Complete', 19);

-- Additional duels for more data
INSERT INTO "Duel" (player_id, action_document_id, action_video_id, match_minute, timestamp_seconds, duel_type, outcome, opponent_player_id, x_coordinate, y_coordinate) VALUES
(2, NULL, NULL, 12, 720, 'Aerial', 'Won', NULL, 82.00, 34.00),
(3, NULL, NULL, 16, 960, 'Ground', 'Won', NULL, 78.00, 40.00),
(4, NULL, NULL, 24, 1440, 'Tackle', 'Won', NULL, 32.00, 18.00),
(2, NULL, NULL, 33, 1980, 'Aerial', 'Lost', NULL, 88.00, 34.00),
(3, NULL, NULL, 48, 2880, 'Ground', 'Won', NULL, 70.00, 35.00),
(4, NULL, NULL, 58, 3480, 'Tackle', 'Won', NULL, 28.00, 22.00),
(2, NULL, NULL, 68, 4080, 'Aerial', 'Won', NULL, 85.00, 34.00),
(14, NULL, NULL, 10, 600, 'Aerial', 'Won', NULL, 78.00, 34.00),
(15, NULL, NULL, 18, 1080, 'Tackle', 'Won', NULL, 30.00, 18.00),
(14, NULL, NULL, 28, 1680, 'Aerial', 'Won', NULL, 82.00, 34.00),
(13, NULL, NULL, 35, 2100, 'Ground', 'Won', NULL, 75.00, 12.00),
(15, NULL, NULL, 48, 2880, 'Tackle', 'Lost', NULL, 28.00, 25.00),
(14, NULL, NULL, 62, 3720, 'Aerial', 'Won', NULL, 80.00, 34.00),
(13, NULL, NULL, 72, 4320, 'Ground', 'Won', NULL, 78.00, 10.00);

-- Additional goals for a more complete dataset
INSERT INTO "Goal" (player_id, action_document_id, action_video_id, match_minute, timestamp_seconds, goal_type, body_part, x_coordinate, y_coordinate, assisting_player_id) VALUES
(21, NULL, NULL, 58, 3480, 'Open Play', 'Right Foot', 101.00, 34.00, 17),
(7, NULL, NULL, 75, 4500, 'Counter Attack', 'Right Foot', 99.50, 30.00, 6),
(8, NULL, NULL, 82, 4920, 'Open Play', 'Left Foot', 100.00, 38.00, 5),
(19, NULL, NULL, 85, 5100, 'Counter Attack', 'Right Foot', 102.00, 32.00, 16);

-- Additional assists
INSERT INTO "Assist" (player_id, action_document_id, action_video_id, match_minute, timestamp_seconds, assist_type, goal_scorer_id, goal_id, x_coordinate, y_coordinate) VALUES
(17, NULL, NULL, 58, 3478, 'Short Pass', 21, 6, 88.00, 38.00),
(6, NULL, NULL, 75, 4498, 'Through Ball', 7, 7, 68.00, 34.00),
(5, NULL, NULL, 82, 4918, 'Cross', 8, 8, 90.00, 8.00),
(16, NULL, NULL, 85, 5098, 'Long Ball', 19, 9, 52.00, 34.00);

-- Additional cards
INSERT INTO "Card" (player_id, card_type, match_minute, timestamp_seconds, reason, action_document_id, action_video_id) VALUES
(4, 'Yellow', 45, 2700, 'Tactical Foul', NULL, NULL),
(9, 'Yellow', 62, 3720, 'Reckless Challenge', NULL, NULL),
(13, 'Yellow', 48, 2880, 'Tactical Foul', NULL, NULL),
(16, 'Yellow', 68, 4080, 'Unsporting Behavior', NULL, NULL),
(20, 'Yellow', 82, 4920, 'Delay of Game', NULL, NULL);

-- Additional freekicks
INSERT INTO "Freekick" (player_id, action_document_id, action_video_id, match_minute, timestamp_seconds, freekick_type, outcome, x_coordinate, y_coordinate) VALUES
(5, NULL, NULL, 48, 2880, 'Direct', 'Saved', 86.00, 28.00),
(17, NULL, NULL, 52, 3120, 'Indirect', 'Complete Pass', 78.00, 34.00),
(7, NULL, NULL, 70, 4200, 'Direct', 'Off Target', 88.00, 38.00),
(18, NULL, NULL, 75, 4500, 'Direct', 'On Target', 90.00, 34.00);

-- Additional wellness tests for different dates
INSERT INTO "Wellness_Test" (player_id, test_date, fatigue_score, stress_score, sleep_quality_score, muscle_soreness_score, mood_score, readiness_score, comments) VALUES
(2, '2024-09-11', 3, 2, 4, 3, 4, 4, 'Normal recovery pattern'),
(3, '2024-09-11', 2, 2, 5, 2, 5, 5, 'Excellent recovery'),
(7, '2024-09-11', 4, 3, 3, 4, 3, 3, 'Some muscle soreness post-match'),
(10, '2024-09-11', 3, 2, 4, 3, 4, 4, 'Good overall condition'),
(13, '2024-09-11', 2, 1, 5, 1, 5, 5, 'Feeling very fresh'),
(16, '2024-09-11', 3, 2, 4, 2, 4, 4, 'Ready for next match'),
(19, '2024-09-11', 2, 2, 5, 1, 5, 5, 'Optimal condition');

-- Additional physical tests
INSERT INTO "Physical_Test" (player_id, test_date, test_type, result_value, result_unit, baseline_value, test_conditions) VALUES
(7, '2024-08-15', 'VO2 Max', 64.00, 'ml/kg/min', 62.00, 'Laboratory test, fasted state'),
(10, '2024-08-15', 'Sprint 30m', 3.92, 'seconds', 3.95, 'Outdoor track, optimal conditions'),
(16, '2024-08-15', 'Vertical Jump', 72.00, 'cm', 70.00, 'Indoor facility'),
(19, '2024-08-15', 'Yo-Yo Test', 2600.00, 'meters', 2520.00, 'Training ground'),
(3, '2024-08-15', 'Sprint 30m', 3.88, 'seconds', 3.90, 'Outdoor track'),
(14, '2024-08-15', 'Vertical Jump', 65.00, 'cm', 64.00, 'Indoor facility');

-- Additional satisfaction tests
INSERT INTO "Satisfaction_Test" (player_id, test_date, coach_relationship_score, team_atmosphere_score, playing_time_satisfaction, training_quality_score, overall_satisfaction, comments) VALUES
(7, '2024-09-01', 5, 5, 4, 5, 5, 'Very satisfied with progress'),
(8, '2024-09-01', 5, 5, 5, 5, 5, 'Perfect environment'),
(18, '2024-09-01', 5, 5, 5, 5, 5, 'Excellent in all aspects'),
(19, '2024-09-01', 5, 5, 5, 5, 5, 'Great team spirit'),
(2, '2024-09-01', 4, 5, 4, 4, 4, 'Happy overall');

-- Additional training sessions
INSERT INTO "Training" (team_id, training_date, training_type, duration_minutes, location) VALUES
(1, '2024-09-13', 'Tactical', 85, 'Ciutat Esportiva Joan Gamper'),
(1, '2024-09-14', 'Light Training', 45, 'Ciutat Esportiva Joan Gamper'),
(2, '2024-09-12', 'Technical', 75, 'Ciudad Deportiva Valdebebas'),
(2, '2024-09-13', 'Tactical', 90, 'Ciudad Deportiva Valdebebas'),
(2, '2024-09-14', 'Recovery', 40, 'Ciudad Deportiva Valdebebas'),
(3, '2024-09-10', 'Physical', 70, 'Ciudad Deportiva Wanda'),
(3, '2024-09-11', 'Tactical', 85, 'Ciudad Deportiva Wanda');

-- Additional training exercises
INSERT INTO "Training_Exercise" (training_id, exercise_name, exercise_type, duration_minutes, intensity, description) VALUES
(6, 'Build-up Play', 'Tactical', 35, 'Medium', 'Progression from defense to attack'),
(6, 'Set Piece Practice', 'Tactical', 25, 'Low', 'Corner kicks and free kicks'),
(7, 'Recovery Run', 'Physical', 20, 'Low', 'Light jogging for recovery'),
(7, 'Stretching', 'Physical', 15, 'Low', 'Flexibility and mobility work'),
(8, 'Ball Control', 'Technical', 30, 'Medium', 'First touch and control exercises'),
(8, '1v1 Situations', 'Technical', 25, 'High', 'Attacking and defending duels'),
(9, 'Shape Work', 'Tactical', 40, 'Medium', 'Defensive and offensive formations'),
(9, 'Transition Drills', 'Tactical', 30, 'High', 'Quick transitions defense to attack'),
(11, 'Strength Training', 'Physical', 35, 'High', 'Gym session - lower body'),
(11, 'Agility Drills', 'Physical', 20, 'Medium', 'Ladder and cone exercises');

-- Summary comment for analytics team
-- This dataset includes:
-- - 10 Nations
-- - 5 Stadiums
-- - 3 Competitions
-- - 5 Legs
-- - 5 Teams
-- - 5 Matches with complete data
-- - 8 Staff members with assignments
-- - 28 Players across teams
-- - Match participation data (Role table)
-- - 9 Goals with assists
-- - 32+ Passes with outcomes
-- - 18+ Duels
-- - 9 Cards (all yellow)
-- - 7 Freekicks
-- - 5 Substitutions
-- - 5 Referees with match assignments
-- - Training sessions and exercises
-- - Wellness, satisfaction, and physical tests
-- - 3 Injury records with body parts
-- - Tracking data paths for players and ball
-- - Action documents and videos
-- - Staff documentation
--
-- The data is interconnected and ready for analytics queries including:
-- - Player performance analysis
-- - Team statistics
-- - Match analysis
-- - Training load monitoring
-- - Injury tracking
-- - Wellness monitoring
-- - Pass completion rates
-- - Goal scoring patterns
-- - And much more!