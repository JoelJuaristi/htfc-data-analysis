CREATE TABLE "Competition"(
    "id" BIGINT NOT NULL,
    "Year" VARCHAR(255) NOT NULL,
    "Name" BIGINT NOT NULL,
    "Level" SMALLINT NULL,
    "Type" VARCHAR(255) NOT NULL
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
CREATE TABLE "Team_Standing"(
    "id" BIGINT NOT NULL,
    "Position" BIGINT NOT NULL,
    "Points" BIGINT NOT NULL,
    "Matchday" BIGINT NOT NULL
);
ALTER TABLE
    "Team_Standing" ADD PRIMARY KEY("id");
CREATE TABLE "Knockout"(
    "id" BIGINT NOT NULL,
    "Round" VARCHAR(255) NOT NULL
);
ALTER TABLE
    "Knockout" ADD PRIMARY KEY("id");
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
CREATE TABLE "Pass"("id" BIGINT NOT NULL);
ALTER TABLE
    "Pass" ADD PRIMARY KEY("id");
CREATE TABLE "Shot"("id" BIGINT NOT NULL);
ALTER TABLE
    "Shot" ADD PRIMARY KEY("id");
CREATE TABLE "Fault"("id" BIGINT NOT NULL);
ALTER TABLE
    "Fault" ADD PRIMARY KEY("id");
CREATE TABLE "Interception"("id" BIGINT NOT NULL);
ALTER TABLE
    "Interception" ADD PRIMARY KEY("id");
CREATE TABLE "Duel"("id" BIGINT NOT NULL);
ALTER TABLE
    "Duel" ADD PRIMARY KEY("id");
CREATE TABLE "Clearance"("id" BIGINT NOT NULL);
ALTER TABLE
    "Clearance" ADD PRIMARY KEY("id");
ALTER TABLE
    "Competition" ADD CONSTRAINT "competition_id_foreign" FOREIGN KEY("id") REFERENCES "Knockout"("id");
ALTER TABLE
    "Team_Standing" ADD CONSTRAINT "team_standing_id_foreign" FOREIGN KEY("id") REFERENCES "Team"("id");
ALTER TABLE
    "Team_Game" ADD CONSTRAINT "team_game_points_foreign" FOREIGN KEY("Points") REFERENCES "Action_Video"("id");
ALTER TABLE
    "Team" ADD CONSTRAINT "team_id_foreign" FOREIGN KEY("id") REFERENCES "Team_Game"("id");
ALTER TABLE
    "Match" ADD CONSTRAINT "match_id_foreign" FOREIGN KEY("id") REFERENCES "Team_Game"("id");
ALTER TABLE
    "Competition" ADD CONSTRAINT "competition_name_foreign" FOREIGN KEY("Name") REFERENCES "Match"("id");
ALTER TABLE
    "Knockout" ADD CONSTRAINT "knockout_id_foreign" FOREIGN KEY("id") REFERENCES "Team"("id");
ALTER TABLE
    "Competition" ADD CONSTRAINT "competition_id_foreign" FOREIGN KEY("id") REFERENCES "Team_Standing"("id");
ALTER TABLE
    "Team_Game" ADD CONSTRAINT "team_game_points_foreign" FOREIGN KEY("Points") REFERENCES "Action_Document"("id");