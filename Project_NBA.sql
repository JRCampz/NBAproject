CREATE SCHEMA project_nba;

CREATE TABLE  officials (
	game_id	INT,
    official_id	INT,
    first_name VARCHAR(30),
    last_name VARCHAR(30),
    jersey_num INT
    );

CREATE TABLE other_stats (
	league_id INT,
    team_id_home INT,
    team_abbreviation_home CHAR(3),
    team_city_home	VARCHAR(30),
    pts_paint_home INT,
    pts_2nd_chance_home INT,	
    pts_fb_home	INT,
    largest_lead_home INT,
    lead_changes INT,	
    times_tied INT,
    team_turnovers_home	INT,
    total_turnovers_home FLOAT,
    team_rebounds_home FLOAT,
    pts_off_to_home	FLOAT,
    team_id_away INT,
    team_abbreviation_away CHAR(3),
    team_city_away VARCHAR(30),
    pts_paint_away INT,
    pts_2nd_chance_away	INT,
    pts_fb_away	INT,
    largest_lead_away INT,	
    team_turnovers_away	INT,
    total_turnovers_away FLOAT,	
    team_rebounds_away FLOAT,
    pts_off_to_away FLOAT
    );
    
CREATE TABLE play_by_play (
	game_id INT,
    eventnum INT,
    eventmsgtype INT,
    eventmsgactiontype INT,
    period INT,
    wctimestring TIME(0),
    pctimestring TIME(0),
    homedescription VARCHAR(50),
    neutraldescription VARCHAR(50),
    visitordescription VARCHAR(50),
    score INT,
    scoremargin INT,
    person1type INT,
    player1_id INT,
    player1_name VARCHAR(50),
    player1_team_id INT,
    player1_team_city VARCHAR(50),
    player1_team_nickname VARCHAR(50),
    player1_team_abbreviation VARCHAR(50),
    person2type INT,
    player2_id INT,
    player2_name VARCHAR(50),
    player2_team_id INT,
    player2_team_city VARCHAR(50),
    player2_team_nickname VARCHAR(50),
    player2_team_abbreviation VARCHAR(50),
    person3type INT,
    player3_id INT,
    player3_name VARCHAR(50),
    player3_team_id INT,
    player3_team_city VARCHAR(50),
    player3_team_nickname VARCHAR(50),
    player3_team_abbreviation VARCHAR(50),
    video_available_flag INT
    );
    
    
CREATE TABLE player (
	id INT,
    full_name VARCHAR(50),
    first_name	VARCHAR(50),
    last_name VARCHAR(50),
    is_active INT
    );
	
CREATE TABLE team (
	id INT,
    full_name VARCHAR(50),
    abbreviation VARCHAR(3),
    nickname VARCHAR(30),
    city VARCHAR(30),
    state VARCHAR(30),
    year_founded YEAR
    );
    
CREATE TABLE team_detail (
	team_id	INT,
    abbreviation CHAR(3),
    nickname VARCHAR(30),
    yearfounded	YEAR,
    city VARCHAR(30),
    arena VARCHAR(30),
    arenacapacity INT,
    `owner` VARCHAR(30),
    generalmanager VARCHAR(30),
    headcoach VARCHAR(30),
    dleagueaffiliation VARCHAR(30),
    facebook TEXT,	
    instagram TEXT,
    twitter TEXT
    );
    
CREATE TABLE team_history (
	team_id	INT,
    city VARCHAR(50),
    nickname VARCHAR(50),
    year_founded YEAR,
    year_active_till YEAR
    );
    
CREATE TABLE team_info_common (
	team_id	INT,
    season_year	YEAR,
    team_city VARCHAR(30),
    team_name VARCHAR(30),
    team_abbreviation CHAR(3),
    team_conference	VARCHAR(5),
    team_division VARCHAR(20),
    team_code VARCHAR(30),
    team_slug VARCHAR(30),
    w INT,
    l INT,
    pct	FLOAT,
    conf_rank INT,
    div_rank INT,
    min_year YEAR,
    max_year YEAR,
    league_id INT,	
    season_id INT,
    pts_rank INT,
    pts_pg FLOAT,
    reb_rank INT,	
    reb_pg FLOAT,
    ast_rank INT,
    ast_pg FLOAT,
    opp_pts_rank INT,
    opp_pts_pg FLOAT
);

