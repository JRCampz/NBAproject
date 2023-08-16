CREATE SCHEMA project_nba;

USE project_nba;

CREATE TABLE player_info (
    person_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    display_first_last VARCHAR(50),
    display_last_comma_first VARCHAR(50),
    display_fi_last VARCHAR(50),
    player_slug VARCHAR(50),
    birthdate DATE,
    school VARCHAR(50),
    country VARCHAR(50),
    last_affiliation VARCHAR(50),
    height VARCHAR(50),
    weight INT,
    season_exp FLOAT,
    jersey VARCHAR(50),
    position VARCHAR(50),
    rosterstatus VARCHAR(50),
    games_played_current_season_flag VARCHAR(50),
    team_id INT,
    team_name VARCHAR(50),
    team_abbreviation VARCHAR(50),
    team_code VARCHAR(50),
    team_city VARCHAR(50),
    playercode VARCHAR(50),
    from_year INT,
    to_year INT,
    dleague_flag VARCHAR(50),
    nba_flag VARCHAR(50),
    games_played_flag VARCHAR(50),
    draft_year INT,
    draft_round INT,
    draft_number INT,
    greatest_75_flag VARCHAR(50)
    );
    



CREATE TABLE team_info (
    team_id INT,
    season_year VARCHAR(9),
    team_city VARCHAR(50),
    team_name VARCHAR(50),
    team_abbreviation VARCHAR(3),
    team_conference VARCHAR(4),
    team_division VARCHAR(10),
    team_code VARCHAR(20),
    team_slug VARCHAR(20),
    w INT,
    l INT,
    pct DOUBLE,
    conf_rank INT,
    div_rank INT,
    min_year INT,
    max_year INT,
    league_id INT,
    season_id INT,
    pts_rank INT,
    pts_pg DOUBLE,
    reb_rank INT,
    reb_pg DOUBLE,
    ast_rank INT,
    ast_pg DOUBLE,
    opp_pts_rank INT,
    opp_pts_pg DOUBLE
);

ALTER TABLE player
ADD CONSTRAINT pk_player_id PRIMARY KEY (id);

ALTER TABLE player_info
ADD CONSTRAINT pk_player_info_person_id PRIMARY KEY (person_id);

ALTER TABLE team
ADD CONSTRAINT pk_team_id PRIMARY KEY (id);

ALTER TABLE team_info
ADD CONSTRAINT pk_team_info PRIMARY KEY (team_id, season_year);

ALTER TABLE player_info
ADD CONSTRAINT fk_player_info_person_id FOREIGN KEY (person_id)
REFERENCES player(id);

ALTER TABLE team_info
ADD CONSTRAINT fk_team_info_team_id FOREIGN KEY (team_id)
REFERENCES team(id);

CREATE TABLE other_stats ( 
  league_id INT,
  team_id_home INT,
  team_abbreviation_home VARCHAR(9),
  team_city_home VARCHAR(30),
  pts_paint_home INT,
  pts_2nd_chance_home INT,
  pts_fb_home INT,
  largest_lead_home INT,
  lead_changes INT,
  times_tied INT,
  team_turnovers_home DOUBLE,
  total_turnovers_home DOUBLE,
  team_rebounds_home DOUBLE,
  pts_off_to_home DOUBLE,
  team_id_away INT,
  team_abbreviation_away VARCHAR(10),
  team_city_away VARCHAR(30),
  pts_paint_away INT,
  pts_2nd_chance_away INT,
  pts_fb_away INT,
  largest_lead_away INT,
  team_turnovers_away DOUBLE,
  total_turnovers_away DOUBLE,
  team_rebounds_away DOUBLE,
  pts_off_to_away DOUBLE
);

ALTER TABLE other_stats
MODIFY team_turnovers_away INT;

ALTER TABLE other_stats
MODIFY team_turnovers_home INT;

ALTER TABLE other_stats 
ADD CONSTRAINT fk_team_home
FOREIGN KEY (team_id_home) REFERENCES team (id);

ALTER TABLE other_stats 
ADD CONSTRAINT fk_team_away
FOREIGN KEY (team_id_away) REFERENCES team (id);

CREATE TABLE game (
  season_id INT,
  team_id_home INT,
  team_abbreviation_home VARCHAR(225),
  team_name_home VARCHAR(225),
  game_id INT PRIMARY KEY,
  game_date DATE,
  matchup_home VARCHAR(225),
  wl_home VARCHAR(225),
  min INT,
  fgm_home TEXT,
  fga_home TEXT,
  fg_pct_home TEXT,
  fg3m_home TEXT,
  fg3a_home TEXT,
  fg3_pct_home TEXT,
  ftm_home TEXT,
  fta_home TEXT,
  ft_pct_home TEXT,
  oreb_home TEXT,
  dreb_home TEXT,
  reb_home TEXT,
  ast_home TEXT,
  stl_home TEXT,
  blk_home TEXT,
  tov_home TEXT,
  pf_home TEXT,
  pts_home INT,
  plus_minus_home INT,
  video_available_home INT,
  team_id_away INT,
  team_abbreviation_away VARCHAR(20),
  team_name_away VARCHAR(225),
  matchup_away VARCHAR(225),
  wl_away VARCHAR(225),
  fgm_away TEXT,
  fga_away TEXT,
  fg_pct_away TEXT,
  fg3m_away TEXT,
  fg3a_away TEXT,
  fg3_pct_away TEXT,
  ftm_away TEXT,
  fta_away TEXT,
  ft_pct_away TEXT,
  oreb_away TEXT,
  dreb_away TEXT,
  reb_away TEXT,
  ast_away TEXT,
  stl_away TEXT,
  blk_away TEXT,
  tov_away TEXT,
  pf_away TEXT,
  pts_away INT,
  plus_minus_away INT,
  video_available_away INT
);

ALTER TABLE other_stats
MODIFY team_turnovers_away INT;

ALTER TABLE other_stats
MODIFY team_turnovers_home INT;

ALTER TABLE other_stats 
ADD CONSTRAINT fk_team_home
FOREIGN KEY (team_id_home) REFERENCES team (id);

ALTER TABLE other_stats 
ADD CONSTRAINT fk_team_away
FOREIGN KEY (team_id_away) REFERENCES team (id);


ALTER TABLE player_info
ADD height_cm double;

UPDATE player_info
SET height_cm = (SUBSTRING_INDEX(height, "-", 1) * 30.48 + SUBSTRING_INDEX(height, "-", -1) * 2.54)
WHERE height LIKE '%-%';


# AVERAGE HEIGH PER POSITION
SELECT position,  AVG(height_cm) AS avg_height
FROM player_info
GROUP BY position;


#MOST EXPERIENCE PLAYERS ON NBA 

SELECT display_first_last, season_exp
FROM player_info
ORDER BY season_exp DESC;


# TEAMS WITH MORE REBOUNDS

SELECT team_info.team_name, SUM(oreb_home) AS total_H_rebounds, SUM(oreb_away) AS total_A_rebounds, (SUM(game.oreb_home + game.oreb_away)) AS total_rebounds
FROM game
JOIN team_info ON game.team_id_home = team_info.team_id
GROUP BY team_info.team_name
ORDER BY total_rebounds DESC;

#TEAMS TURNOVERS HOME VS AWAY

SELECT t.team_name, SUM(os.team_turnovers_home) AS total_turnovers_home, SUM(os.team_turnovers_away) AS total_turnovers_away
FROM team_info t
JOIN other_stats os
ON t.team_id = os.team_id_home OR t.team_id = os.team_id_away
GROUP BY t.team_name
ORDER BY total_turnovers_home desc;

#TEAM LEADS HOME VS AWAY

SELECT t.team_name, SUM(CASE WHEN os.team_id_home = t.team_id THEN os.lead_changes ELSE 0 END) AS lead_changes_home, SUM(CASE WHEN os.team_id_away = t.team_id THEN os.lead_changes ELSE 0 END) AS lead_changes_away
FROM team_info t
JOIN other_stats os
ON t.team_id = os.team_id_home OR t.team_id = os.team_id_away
GROUP BY t.team_name
ORDER BY lead_changes_home DESC;

# TEAMS AVERAGE POINST HOME AND AWAY

SELECT team_info.team_name, AVG(game.pts_home) AS avg_points_home, AVG(game.pts_away) AS avg_points_away
FROM game
JOIN team_info ON game.team_id_home = team_info.team_id OR game.team_id_away = team_info.team_id
GROUP BY team_info.team_name;













