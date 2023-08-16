import pandas as pd
import sqlalchemy as sql
import mysql.connector
import matplotlib.pyplot as plt
import streamlit as st

connection = mysql.connector.connect(user = 'root', password = 'Equipament0', host = '127.0.0.1', port = '3306', database = 'project_nba', use_pure = True)
#queries 
query_height = '''
# AVERAGE HEIGH PER POSITION
SELECT position,  AVG(height_cm) AS avg_height
FROM player_info
GROUP BY position;
'''

query_heighest ='''
#TEAMS HIGHEST PLAYERS 

SELECT t.team_name, p.display_first_last, p.height_cm AS heightest_player
FROM player_info p
JOIN team_info t ON p.team_id = t.team_id
WHERE p.height_cm = (
  SELECT MAX(height_cm) 
  FROM player_info 
  WHERE team_id = p.team_id
)
ORDER BY heightest_player DESC;
'''

query_exp = '''
#PLAYER WITH MOST SEASONS EXPERIENCE FOR EACH TEAM

SELECT t.team_name, p.display_first_last, p.season_exp
FROM (
  SELECT team_id, MAX(season_exp) AS max_season_exp
  FROM player_info
  GROUP BY team_id
) AS max_exp
JOIN player_info p ON p.team_id = max_exp.team_id AND p.season_exp = max_exp.max_season_exp
JOIN team_info t ON t.team_id = p.team_id
ORDER BY t.team_name;
'''

query_turnovers = '''
#TEAMS TURNOVERS HOME VS AWAY

SELECT t.team_name,
       sum(os.team_turnovers_home) AS total_turnovers_home,
       sum(os.team_turnovers_away) AS total_turnovers_away
       
FROM team_info t
JOIN other_stats os
ON t.team_id = os.team_id_home OR t.team_id = os.team_id_away
GROUP BY t.team_name
ORDER BY total_turnovers_home desc;
'''

query_leads = '''
#TEAM LEADS HOME VS AWAY

SELECT t.team_name,
       SUM(CASE WHEN os.team_id_home = t.team_id THEN os.lead_changes ELSE 0 END) AS lead_changes_home,
       SUM(CASE WHEN os.team_id_away = t.team_id THEN os.lead_changes ELSE 0 END) AS lead_changes_away
FROM team_info t
JOIN other_stats os
ON t.team_id = os.team_id_home OR t.team_id = os.team_id_away
GROUP BY t.team_name
ORDER BY lead_changes_home DESC;
'''
query_rebounds = '''
# TEAMS WITH MOST REBOUNDS

SELECT ti.team_name, SUM(os.team_rebounds_home) AS total_home_rebounds, SUM(os.team_rebounds_away) AS total_away_rebounds, SUM(os.team_rebounds_home + os.team_rebounds_away) AS total_rebounds
FROM other_stats AS os
INNER JOIN team_info AS ti ON os.team_id_home = ti.team_id
GROUP BY ti.team_name
ORDER BY total_rebounds DESC;
'''
df_height = pd.read_sql_query(query_height, con=connection)
df_heighest = pd.read_sql_query(query_heighest, con=connection)
df_exp = pd.read_sql_query(query_exp, con=connection)
df_turnovers = pd.read_sql_query(query_turnovers, con=connection)
df_leads = pd.read_sql_query(query_leads, con=connection)
df_rebounds = pd.read_sql_query(query_rebounds, con=connection)

print(df_leads)
    
# read data from CSV files
player_info = pd.read_csv('common_player_info.csv')
team_info = pd.read_csv('team_info_common.csv')
other_stats = pd.read_csv('other_stats.csv')


positions = df_height["position"]
avg_heights = df_height["avg_height"]

fig, ax = plt.subplots()
ax.bar(positions, avg_heights)
ax.set_title("Average Height per Position")
ax.set_xlabel("Position")
ax.set_ylabel("Height (cm)")
plt.xticks(rotation=45)
plt.show()
# Viz for height per position
positions = df_height["position"]
avg_heights = df_height["avg_height"]

fig, ax = plt.subplots()
ax.bar(positions, avg_heights)
ax.set_title("Average Height per Position")
ax.set_xlabel("Position")
ax.set_ylabel("Height (cm)")
plt.xticks(rotation=45)
plt.show()

team = df_heighest['team_name']
heighest_p = df_heighest['heightest_player']

plt.figure(figsize=(10,6))
plt.bar(team, heighest_p)
plt.xticks(rotation=90)
plt.title('Height of the Tallest Player on Each Team')
plt.xlabel('Team')
plt.ylabel('Height (cm)')
plt.show()
#visualization for heightest player

team = df_heighest['team_name']
heighest_p = df_heighest['heightest_player']

plt.figure(figsize=(10,6))
plt.bar(team, heighest_p)
plt.xticks(rotation=90)
plt.title('Height of the Tallest Player on Each Team')
plt.xlabel('Team')
plt.ylabel('Height (cm)')
plt.show()

team = df_exp['team_name']
exp = df_exp['season_exp']

plt.figure(figsize=(10, 6))
plt.bar(team, exp)
plt.xticks(rotation=90)
plt.title('Player with the most seasons experience for each team')
plt.xlabel('Team')
plt.ylabel('Seasons of experience')
plt.show()
#visualization for experience players 

team = df_exp['team_name']
exp = df_exp['season_exp']

plt.figure(figsize=(10, 6))
plt.bar(team, exp)
plt.xticks(rotation=90)
plt.title('Player with the most seasons experience for each team')
plt.xlabel('Team')
plt.ylabel('Seasons of experience')
plt.show()

fig, ax = plt.subplots(figsize=(10, 8))
ax.barh(df_turnovers['team_name'], df_turnovers['total_turnovers_home'], label='Home')
ax.barh(df_turnovers['team_name'], df_turnovers['total_turnovers_away'], left=df_turnovers['total_turnovers_home'], label='Away')
ax.set_xlabel('Total Turnovers')
ax.set_ylabel('Team')
ax.set_title('Team Turnovers at Home vs Away')
ax.legend()
plt.show()
#visualization for turnovers

fig, ax = plt.subplots(figsize=(10, 8))
ax.barh(df_turnovers['team_name'], df_turnovers['total_turnovers_home'], label='Home')
ax.barh(df_turnovers['team_name'], df_turnovers['total_turnovers_away'], left=df_turnovers['total_turnovers_home'], label='Away')
ax.set_xlabel('Total Turnovers')
ax.set_ylabel('Team')
ax.set_title('Team Turnovers at Home vs Away')
ax.legend()
plt.show()

fig, ax = plt.subplots(figsize=(10,6))
ax.barh(df_leads['team_name'], df_leads['lead_changes_home'], label='Home')
ax.barh(df_leads['team_name'], df_leads['lead_changes_away'], left=df_leads['lead_changes_home'], label='Away')
ax.set_xlabel('Team')
ax.set_ylabel('Lead Changes')
ax.set_title('Team Lead Changes at Home vs Away')
ax.legend()
plt.xticks(rotation=90)
plt.show()
# visualization for the leads query

fig, ax = plt.subplots(figsize=(10,6))
ax.barh(df_leads['team_name'], df_leads['lead_changes_home'], label='Home')
ax.barh(df_leads['team_name'], df_leads['lead_changes_away'], left=df_leads['lead_changes_home'], label='Away')
ax.set_xlabel('Team')
ax.set_ylabel('Lead Changes')
ax.set_title('Team Lead Changes at Home vs Away')
ax.legend()
plt.xticks(rotation=90)
plt.show()

fig, ax = plt.subplots(figsize=(10,6))
ax.bar(df_rebounds['team_name'], df_rebounds['total_rebounds'])
ax.set_xlabel('Team')
ax.set_ylabel('Total Rebounds')
ax.set_title('Teams with Most Rebounds')
plt.xticks(rotation=90)
plt.show()
# visualization for rebounds 

fig, ax = plt.subplots(figsize=(10,6))
ax.bar(df_rebounds['team_name'], df_rebounds['total_rebounds'])
ax.set_xlabel('Team')
ax.set_ylabel('Total Rebounds')
ax.set_title('Teams with Most Rebounds')
plt.xticks(rotation=90)
plt.show()

#Streamlite
st.set_page_config(
    page_title="NBA Project ",
    page_icon=":smiley:",
  #  layout="wide",
)

dash = st.sidebar.radio(
    "Choose a dashboard to see !",
    ('Height per Position', 'Teams Tallest Player', 'Most Experience Players', 'Turnovers', 'Leads', 'Rebounds'))
     

    
#Height per position
if dash == 'Height per Position':
    st.title('Height per Position dashboard !')
    positions = df_height["position"]
    avg_heights = df_height["avg_height"]

    fig_heigt, ax = plt.subplots()
    ax.bar(positions, avg_heights)
    ax.set_title("Average Height per Position")
    ax.set_xlabel("Position")
    ax.set_ylabel("Height (cm)")
    plt.xticks(rotation=45)
    st.pyplot(fig_heigt)

#tallest player per team
elif dash == 'Teams Tallest Player' :
    st.title ('Teams Tallest Player Dashboard !')
    team = df_heighest['team_name']
    heighest_p = df_heighest['heightest_player']

    fig_t_height = plt.figure(figsize=(10,6))
    plt.bar(team, heighest_p)
    plt.xticks(rotation=90)
    plt.title('Height of the Tallest Player on Each Team')
    plt.xlabel('Team')
    plt.ylabel('Height (cm)')
    st.pyplot(fig_t_height)

# Most Experience Players
 

elif dash == 'Most Experience Players':
    st.title ('Teams With Most Experience Players Dashboard!')
    team = df_exp['team_name']
    exp = df_exp['season_exp']
    

    fig_exp = plt.figure(figsize=(10, 6))
    plt.bar(team, exp)
    plt.xticks(rotation=90)
    plt.title('Player with the most seasons experience for each team')
    plt.xlabel('Team')
    plt.ylabel('Seasons of experience')
    st.pyplot(fig_exp)
#Turnovers
              
elif dash == 'Turnovers':
    st.title ('Teams with Most turnovers Dashboard')
    fig_turnovers, ax = plt.subplots(figsize=(10, 8))
    ax.barh(df_turnovers['team_name'], df_turnovers['total_turnovers_home'], label='Home')
    ax.barh(df_turnovers['team_name'], df_turnovers['total_turnovers_away'], left=df_turnovers['total_turnovers_home'], label='Away')
    ax.set_xlabel('Total Turnovers')
    ax.set_ylabel('Team')
    ax.set_title('Team Turnovers at Home vs Away')
    ax.legend()
    st.pyplot(fig_turnovers)
    
 
elif dash == 'Leads':
    st.title ('Teams with most lead changes Dashboard')
    fig_leads, ax = plt.subplots(figsize=(10,6))
    ax.barh(df_leads['team_name'], df_leads['lead_changes_home'], label='Home')
    ax.barh(df_leads['team_name'], df_leads['lead_changes_away'], left=df_leads['lead_changes_home'], label='Away')
    ax.set_xlabel('Team')
    ax.set_ylabel('Lead Changes')
    ax.set_title('Team Lead Changes at Home vs Away')
    ax.legend()
    plt.xticks(rotation=90)
    st.pyplot(fig_leads)


elif dash == 'Rebounds':
    st.title ('Teams with most Rebounds Dashboard')
    fig_rebounds, ax = plt.subplots(figsize=(10,6))
    ax.bar(df_rebounds['team_name'], df_rebounds['total_rebounds'])
    ax.set_xlabel('Team')
    ax.set_ylabel('Total Rebounds')
    ax.set_title('Teams with Most Rebounds')
    plt.xticks(rotation=90)
    st.pyplot(fig_rebounds)
