CREATE TABLE "Competition"(
    "id" BIGINT NOT NULL,
    "Year" VARCHAR(255) NOT NULL,
    "Name" BIGINT NOT NULL,
    "Level" SMALLINT NULL,
    "Type" VARCHAR(255) NOT NULL,
    "Location" VARCHAR(255) NOT NULL,
    "Region" BIGINT NULL
);
ALTER TABLE
    "Competition" ADD PRIMARY KEY("id");
COMMENT
ON COLUMN
    "Competition"."Year" IS 'Year of the competition. Format: 2024/25';
COMMENT
ON COLUMN
    "Competition"."Level" IS 'Only applies to league competitions.';
COMMENT
ON COLUMN
    "Competition"."Type" IS 'League/FA/League cup/Community Shield...';
CREATE TABLE "Team"("id" BIGINT NOT NULL);
ALTER TABLE
    "Team" ADD PRIMARY KEY("id");
CREATE TABLE "Match"(
    "id" BIGINT NOT NULL,
    "Round" VARCHAR(255) NULL,
    "Referee" BIGINT NOT NULL,
    "Stadium" VARCHAR(255) NOT NULL,
    "Date" DATE NOT NULL,
    "Video" VARCHAR(255) NOT NULL,
    "Matchday" INTEGER NOT NULL,
    "Group" SMALLINT NULL
);
ALTER TABLE
    "Match" ADD PRIMARY KEY("id");
CREATE TABLE "Team_Game"(
    "id" BIGINT NOT NULL,
    "Is_host" BOOLEAN NOT NULL,
    "Points" SMALLINT NULL
);
ALTER TABLE
    "Team_Game" ADD PRIMARY KEY("id");
COMMENT
ON COLUMN
    "Team_Game"."Points" IS 'Should be calculated from the goals';
CREATE TABLE "Action_Document"(
    "id" BIGINT NOT NULL,
    "Type" VARCHAR(255) NOT NULL,
    "Minute" INTEGER NOT NULL,
    "Half" SMALLINT NULL
);
ALTER TABLE
    "Action_Document" ADD PRIMARY KEY("id");
COMMENT
ON COLUMN
    "Action_Document"."Half" IS '1 = first half 2 = second half 3 = Extratime 1 4 = extratime 2 5 = Penalties';
CREATE TABLE "Action_Video"(
    "id" BIGINT NOT NULL,
    "Timestamp" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    "Position_x" FLOAT(53) NOT NULL,
    "Position_y" FLOAT(53) NOT NULL,
    "Type" VARCHAR(255) NOT NULL,
    "Minute" INTEGER NOT NULL,
    "Half" SMALLINT NOT NULL
);
ALTER TABLE
    "Action_Video" ADD PRIMARY KEY("id");
COMMENT
ON COLUMN
    "Action_Video"."Half" IS '1 = first half 2 = second half 3 = Extratime 1 4 = extratime 2 5 = Penalties';
CREATE TABLE "Player"("id" BIGINT NOT NULL);
ALTER TABLE
    "Player" ADD PRIMARY KEY("id");
CREATE TABLE "nationality"("id" BIGINT NOT NULL);
ALTER TABLE
    "nationality" ADD PRIMARY KEY("id");
CREATE TABLE "staff"("id" BIGINT NOT NULL);
ALTER TABLE
    "staff" ADD PRIMARY KEY("id");
CREATE TABLE "staff_Game"("id" BIGINT NOT NULL);
ALTER TABLE
    "staff_Game" ADD PRIMARY KEY("id");
CREATE TABLE "staff_team"(
    "id" BIGINT NOT NULL,
    "year" BIGINT NOT NULL,
    "type" BIGINT NOT NULL
);
ALTER TABLE
    "staff_team" ADD PRIMARY KEY("id");
CREATE TABLE "Action_Document_Staff"(
    "id" BIGINT NOT NULL,
    "Type" VARCHAR(255) NOT NULL,
    "Minute" INTEGER NOT NULL,
    "Half" SMALLINT NULL
);
ALTER TABLE
    "Action_Document_Staff" ADD PRIMARY KEY("id");
COMMENT
ON COLUMN
    "Action_Document_Staff"."Half" IS '1 = first half 2 = second half 3 = Extratime 1 4 = extratime 2 5 = Penalties';
CREATE TABLE "Role"(
    "id" BIGINT NOT NULL,
    "Position" VARCHAR(255) NOT NULL,
    "tactic" VARCHAR(255) NOT NULL,
    "start_timebigint" TIME(0) WITHOUT TIME ZONE NOT NULL,
    "end_time" TIME(0) WITHOUT TIME ZONE NOT NULL,
    "time" FLOAT(53) NOT NULL,
    "x_average" FLOAT(53) NOT NULL,
    "y_average" FLOAT(53) NOT NULL
);
ALTER TABLE
    "Role" ADD PRIMARY KEY("id");
CREATE TABLE "Tracking"(
    "id" BIGINT NOT NULL,
    "new_column" BIGINT NOT NULL
);
ALTER TABLE
    "Tracking" ADD PRIMARY KEY("id");
CREATE TABLE "Ball_tracking"("id" BIGINT NOT NULL);
ALTER TABLE
    "Ball_tracking" ADD PRIMARY KEY("id");
ALTER TABLE
    "Team_Game" ADD CONSTRAINT "team_game_id_foreign" FOREIGN KEY("id") REFERENCES "Role"("id");
ALTER TABLE
    "staff_Game" ADD CONSTRAINT "staff_game_id_foreign" FOREIGN KEY("id") REFERENCES "staff"("id");
ALTER TABLE
    "Tracking" ADD CONSTRAINT "tracking_new_column_foreign" FOREIGN KEY("new_column") REFERENCES "Player"("id");
ALTER TABLE
    "staff_team" ADD CONSTRAINT "staff_team_year_foreign" FOREIGN KEY("year") REFERENCES "staff"("id");
ALTER TABLE
    "staff" ADD CONSTRAINT "staff_id_foreign" FOREIGN KEY("id") REFERENCES "Action_Document_Staff"("id");
ALTER TABLE
    "Team_Game" ADD CONSTRAINT "team_game_points_foreign" FOREIGN KEY("Points") REFERENCES "Action_Video"("id");
ALTER TABLE
    "Team_Game" ADD CONSTRAINT "team_game_is_host_foreign" FOREIGN KEY("Is_host") REFERENCES "staff_Game"("id");
ALTER TABLE
    "Team" ADD CONSTRAINT "team_id_foreign" FOREIGN KEY("id") REFERENCES "Team_Game"("id");
ALTER TABLE
    "Team_Game" ADD CONSTRAINT "team_game_points_foreign" FOREIGN KEY("Points") REFERENCES "Action_Document_Staff"("id");
ALTER TABLE
    "Match" ADD CONSTRAINT "match_id_foreign" FOREIGN KEY("id") REFERENCES "Team_Game"("id");
ALTER TABLE
    "Competition" ADD CONSTRAINT "competition_name_foreign" FOREIGN KEY("Name") REFERENCES "Match"("id");
ALTER TABLE
    "nationality" ADD CONSTRAINT "nationality_id_foreign" FOREIGN KEY("id") REFERENCES "staff"("id");
ALTER TABLE
    "Team" ADD CONSTRAINT "team_id_foreign" FOREIGN KEY("id") REFERENCES "staff_team"("id");
ALTER TABLE
    "Player" ADD CONSTRAINT "player_id_foreign" FOREIGN KEY("id") REFERENCES "nationality"("id");
ALTER TABLE
    "Player" ADD CONSTRAINT "player_id_foreign" FOREIGN KEY("id") REFERENCES "Role"("id");
ALTER TABLE
    "Team_Game" ADD CONSTRAINT "team_game_points_foreign" FOREIGN KEY("Points") REFERENCES "Tracking"("id");
ALTER TABLE
    "Action_Document" ADD CONSTRAINT "action_document_id_foreign" FOREIGN KEY("id") REFERENCES "Player"("id");
ALTER TABLE
    "Team_Game" ADD CONSTRAINT "team_game_points_foreign" FOREIGN KEY("Points") REFERENCES "Action_Document"("id");
ALTER TABLE
    "Match" ADD CONSTRAINT "match_group_foreign" FOREIGN KEY("Group") REFERENCES "Ball_tracking"("id");