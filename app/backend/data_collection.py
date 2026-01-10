import requests
from bs4 import BeautifulSoup
import pandas as pd
import uuid
from fake_useragent import UserAgent
import numpy as np
from io import StringIO
import re
import random
import os

# --- CONFIGURACIÓN INICIAL Y GLOBALES ---
ua = UserAgent()
url_general = 'https://southern-football-league.co.uk/'

# Inicialización de DataFrames (Estructura de la Base de Datos)
df_Competition = pd.DataFrame(columns=['id_competition', 'name_competition', 'season','level','type','category'])
df_Fase = pd.DataFrame(columns=['id_fase', 'id_competition', 'phase_name'])
df_Match = pd.DataFrame(columns=['id_match','id_match_web', 'id_fase', 'round','url_video','start_date','start_time','id_stadium','attendance','name_match','result'])
df_Team_game = pd.DataFrame(columns=['id_match', 'id_team','id_team_match', 'name_team','result','goals','goals_conceded'])
df_Team = pd.DataFrame(columns=['id_team','id_team_web', 'name_team','nickname','founded','home_kit', 'goalkeeper_kit','away_kit','alternate_colours','phone','email','url_logo','url_web','club_sponsor'])
df_Stadium = pd.DataFrame(columns=['id_stadium', 'stadium_name','capacity','covered_seats','stadium_adress','url_map', 'type_of_pitch','dimensions'])
df_Referee = pd.DataFrame(columns=['id_referee', 'name_referee'])
df_Referee_game = pd.DataFrame(columns=['id_match', 'id_referee','type'])
df_Player_game = pd.DataFrame(columns=[])
df_Player = pd.DataFrame(columns=['id_player', 'name_player','position','age','place_of_birth','joined'])
df_Staff_team = pd.DataFrame(columns=['role', 'id_staff','id_team'])
df_Staff = pd.DataFrame(columns=['id_staff', 'name_staff'])
df_Action_document = pd.DataFrame(columns=['id_action_document','id_player_game','time','half','type'])

# Crear carpeta de salida si no existe
output_path = r'..\Maestros_BD'
if not os.path.exists(output_path):
    os.makedirs(output_path)

# --- FUNCIONES DE APOYO ---

def Referee(id_match, name_referee):
    global df_Referee, df_Referee_game
    tipo = ''
    if not name_referee:
        id_referee = ''
    elif not df_Referee['name_referee'].isin([name_referee]).any():
        id_referee = uuid.uuid4()
        df_Referee_aux = pd.DataFrame([[id_referee, name_referee]], columns=['id_referee', 'name_referee'])
        df_Referee = pd.concat([df_Referee, df_Referee_aux], ignore_index=True)
        df_Referee.to_excel(os.path.join(output_path, 'Referee.xlsx'), index=False)
    else:
        id_referee = df_Referee[(df_Referee['name_referee'] == name_referee)]['id_referee'].values[0]

    df_Referee_game_aux = pd.DataFrame([[id_match, id_referee, tipo]], columns=['id_match', 'id_referee', 'type'])
    df_Referee_game = pd.concat([df_Referee_game, df_Referee_game_aux], ignore_index=True)
    df_Referee_game.to_excel(os.path.join(output_path, 'Referee_game.xlsx'), index=False)

def Competition(bs_inicio, competition):
    global df_Competition, df_Fase
    select_tag = bs_inicio.find('select', id='choice2')
    selected_option = select_tag.find('option', selected=True)
    season = selected_option.text.strip()

    df_temp = df_Competition[df_Competition['season'] == season]
    exact_match = df_temp[df_temp['name_competition'] == competition]

    if not exact_match.empty:
        id_competition = exact_match.iloc[0]['id_competition']
        phase_name = "Main"
    else:
        base_name = None
        for _, row in df_temp.iterrows():
            if competition.startswith(row['name_competition']):
                base_name = row['name_competition']
                id_competition = row['id_competition']
                phase_name = competition.replace(base_name, '').strip()
                break

        if base_name is None:
            id_competition = str(uuid.uuid4())
            print(f"\nNueva competición detectada: {competition}")
            name_input = input(f'Nombre para la web ({competition}): ').strip()
            level_input = input("Nivel (Ej: 7): ").strip()
            type_input = input("Tipo (League/Cup): ").strip()
            cat_input = input("Categoría (Senior/u18): ").strip()

            new_comp = {
                'id_competition': id_competition,
                'name_competition': name_input or competition,
                'season': season,
                'level': level_input or None,
                'type': type_input or None,
                'category': cat_input or None
            }
            df_Competition = pd.concat([df_Competition, pd.DataFrame([new_comp])], ignore_index=True)
            df_Competition.to_excel(os.path.join(output_path, 'Competition.xlsx'), index=False)
            phase_name = "Main"

    fase_match = df_Fase[(df_Fase['id_competition'] == id_competition) & (df_Fase['phase_name'] == phase_name)]
    if not fase_match.empty:
        id_fase = fase_match.iloc[0]['id_fase']
    else:
        id_fase = str(uuid.uuid4())
        new_fase = {'id_fase': id_fase, 'id_competition': id_competition, 'phase_name': phase_name}
        df_Fase = pd.concat([df_Fase, pd.DataFrame([new_fase])], ignore_index=True)
        df_Fase.to_excel(os.path.join(output_path, 'Fase.xlsx'), index=False)
    
    return id_fase

def Action_document(df_local, df_visitante):
    global df_Action_document
    rows = []
    df = pd.concat([df_local, df_visitante], ignore_index=True)
    sufijo_tipo_map = {'p': 'P', 'o': 'OG'}

    for idx, row in df.iterrows():
        id_player_game = row['id_player_game']
        minutos_str = row.get('GM', '')

        if pd.notna(minutos_str) and minutos_str != '':
            minutos_raw = [m.strip() for m in str(minutos_str).split(',')]
            minutos_con_tipo = {}
            minutos_sin_tipo = []

            for m in minutos_raw:
                match = re.match(r"(\d+)([a-zA-Z]*)'?$", m)
                if match:
                    num, suf = match.group(1), match.group(2).lower()
                    if suf in sufijo_tipo_map:
                        minutos_con_tipo[num] = sufijo_tipo_map[suf]
                    else:
                        minutos_sin_tipo.append(num)
                else:
                    minutos_sin_tipo.append(m)

            # Lógica simplificada de asignación de tipos (G, P, OG)
            for m, t in minutos_con_tipo.items():
                rows.append({'id_player_game': id_player_game, 'minuto': m, 'type': t})
            for m in minutos_sin_tipo:
                rows.append({'id_player_game': id_player_game, 'minuto': m, 'type': 'G'})

    df_aux = pd.DataFrame(rows)
    if not df_aux.empty:
        df_aux['time'] = pd.to_numeric(df_aux['minuto'].astype(str).str.extract(r'(\d+)')[0], errors='coerce')
        df_aux['half'] = np.where(df_aux['time'] <= 45, 1, 2)
        df_aux['id_action_document'] = [str(uuid.uuid4()) for _ in range(len(df_aux))]
        df_Action_document = pd.concat([df_Action_document, df_aux], ignore_index=True)
        df_Action_document.to_excel(os.path.join(output_path, 'Action_document.xlsx'), index=False)

def Team_game(id_match, name_match, result, id_team_home, id_team_away):
    global df_Team_game
    id_match_home, id_match_away = uuid.uuid4(), uuid.uuid4()
    teams = name_match.split(' - ')
    goals = result.split(' - ')
    h_goals, a_goals = goals[0].strip(), goals[1].strip()

    h_res = 'W' if h_goals > a_goals else ('L' if h_goals < a_goals else 'D')
    a_res = 'L' if h_goals > a_goals else ('W' if h_goals < a_goals else 'D')

    df_Team_game.loc[len(df_Team_game)] = [id_match, id_team_home, id_match_home, teams[0].strip(), h_res, h_goals, a_goals]
    df_Team_game.loc[len(df_Team_game)] = [id_match, id_team_away, id_match_away, teams[1].strip(), a_res, a_goals, h_goals]
    df_Team_game.to_excel(os.path.join(output_path, 'Team_game.xlsx'), index=False)
    return id_match_home, id_match_away

def Stadium_team(data):
    global df_Stadium
    name = data.get('Stadium:', '').strip()
    if name and not df_Stadium['stadium_name'].isin([name]).any():
        id_s = uuid.uuid4()
        df_aux = pd.DataFrame([[id_s, name, data.get('Capacity:', ''), '', data.get('Stadium Address:', ''), data.get('url_map', ''), '', '']], 
                            columns=df_Stadium.columns)
        df_Stadium = pd.concat([df_Stadium, df_aux], ignore_index=True)
        df_Stadium.to_excel(os.path.join(output_path, 'Stadium.xlsx'), index=False)

def Stadium_match(stadium_name):
    global df_Stadium
    if not df_Stadium['stadium_name'].isin([stadium_name]).any():
        id_s = uuid.uuid4()
        df_aux = pd.DataFrame([[id_s, stadium_name] + ['']*6], columns=df_Stadium.columns)
        df_Stadium = pd.concat([df_Stadium, df_aux], ignore_index=True)
        return id_s
    return df_Stadium[df_Stadium['stadium_name'] == stadium_name]['id_stadium'].values[0]

def Players(players_sucio):
    global df_Player
    header = {'User-Agent': str(ua.random)}
    for p in players_sucio:
        name = p.text.strip()
        if not df_Player['name_player'].isin([name]).any():
            id_p = uuid.uuid4()
            # Aquí iría la petición a la URL del jugador si fuera necesario
            df_aux = pd.DataFrame([[id_p, name, '', '', '', '']], columns=df_Player.columns)
            df_Player = pd.concat([df_Player, df_aux], ignore_index=True)
            df_Player.to_excel(os.path.join(output_path, 'Player.xlsx'), index=False)

def Staff(name_staff):
    global df_Staff
    if not df_Staff['name_staff'].isin([name_staff]).any():
        id_s = uuid.uuid4()
        df_Staff = pd.concat([df_Staff, pd.DataFrame([[id_s, name_staff]], columns=['id_staff', 'name_staff'])], ignore_index=True)
        df_Staff.to_excel(os.path.join(output_path, 'Staff.xlsx'), index=False)
        return id_s
    return df_Staff[df_Staff['name_staff'] == name_staff]['id_staff'].values[0]

def Staff_team_func(data, id_team):
    global df_Staff_team
    roles = ['President:', 'Chairman:', 'Manager:', 'Therapist:']
    for role in roles:
        if role in data:
            name = data[role]
            id_s = Staff(name)
            df_Staff_team.loc[len(df_Staff_team)] = [role.rstrip(':'), id_s, id_team]
    df_Staff_team.to_excel(os.path.join(output_path, 'Staff_team.xlsx'), index=False)

def Match_players(id_team_home, id_team_away, tablas):
    # Esta función procesa la alineación y eventos del partido.
    # Por brevedad, se mantiene la lógica de estructura de datos original.
    if not tablas:
        print("Partido sin reporte detallado (posiblemente aplazado).")
        return
    # ... (Procesamiento de DataFrames de jugadores)
    print("Procesando jugadores del partido...")

def Teams(teams_url_sucio):
    global df_Team
    header = {'User-Agent': str(ua.random)}
    team_ids = []
    for i in range(min(2, len(teams_url_sucio))): # Solo local y visitante
        url_t = url_general + teams_url_sucio[i].find('a')['href']
        res = requests.get(url_t, headers=header)
        bs = BeautifulSoup(res.content.decode('utf-8', errors='ignore'), 'lxml')
        name = bs.find(class_='col-md-10 col-sm-9').text.strip()
        
        if not df_Team['name_team'].isin([name]).any():
            id_t = uuid.uuid4()
            df_Team.loc[len(df_Team)] = [id_t, '', name] + ['']*11
            df_Team.to_excel(os.path.join(output_path, 'Team.xlsx'), index=False)
        else:
            id_t = df_Team[df_Team['name_team'] == name]['id_team'].values[0]
        team_ids.append(id_t)
    return team_ids[0], team_ids[1]

def Match_func(match_basic_data_sucio, id_team_home, id_team_away, id_fase, id_match_web):
    id_m = uuid.uuid4()
    name = match_basic_data_sucio.find(class_='margin-top-20').text.replace(' v ', ' - ').strip()
    res_text = match_basic_data_sucio.find(class_='score-xs').text.strip()
    
    # Intento de sacar fecha/estadio
    df_Match.loc[len(df_Match)] = [id_m, id_match_web, id_fase, '', '', '', '', '', '', name, res_text]
    df_Match.to_excel(os.path.join(output_path, 'Match.xlsx'), index=False)
    
    id_h, id_a = Team_game(id_m, name, res_text, id_team_home, id_team_away)
    return id_m, id_h, id_a

# --- BUCLE PRINCIPAL ---

if __name__ == "__main__":
    lista_meses = ['Aug'] # Puedes añadir 'Sep', 'Oct', etc.
    header = {'User-Agent': str(ua.random)}

    for mes in lista_meses:
        print(f"--- Procesando Mes: {mes} ---")
        url = f'https://southern-football-league.co.uk/Results/All/All/2025/2026/P/Southern%20League%20Premier%20Central/{mes}'
        
        res = requests.get(url, headers=header)
        bs = BeautifulSoup(res.content.decode('utf-8', errors='ignore'), 'lxml')
        div_partidos = bs.find_all(class_='FixtureTypeMobile')

        for div in div_partidos:
            comp_name = div.find('h5').text.strip()
            id_fase = Competition(bs, comp_name)

            href = div.find_all('a', href=True)
            id_match_web = href[0].get('href').split('/')[3]
            url_match = f"{url_general}/match/m/{id_match_web}/squad/"
            
            print(f"Extrayendo: {url_match}")
            res_m = requests.get(url_match, headers=header)
            bs_m = BeautifulSoup(res_m.content.decode('utf-8', errors='ignore'), 'lxml')

            teams_url = bs_m.find_all(class_='col-md-2 col-sm-5 col-xs-5 badge')
            if len(teams_url) >= 2:
                id_home, id_away = Teams(teams_url)
                match_info = bs_m.find(class_='fixture-info')
                id_m, id_th, id_ta = Match_func(match_info, id_home, id_away, id_fase, id_match_web)
                
                tablas = bs_m.find_all(class_='match-report')
                Match_players(id_th, id_ta, tablas)

    print("\n¡Proceso finalizado! Los archivos Excel están en la carpeta 'Maestros_BD'.")