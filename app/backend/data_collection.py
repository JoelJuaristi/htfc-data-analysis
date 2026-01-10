import requests
from bs4 import BeautifulSoup
import psycopg2
from psycopg2 import extras
from fake_useragent import UserAgent
import re

# --- CONFIGURACIÓN DE CONEXIÓN ---
# Si ejecutas el script desde fuera de Docker, el host suele ser 'localhost'
# Si el script también corriera dentro de Docker, el host sería 'postgres'
DB_CONFIG = {
    "host": "localhost",
    "database": "postgres", # Cambia si creaste una DB específica
    "user": "postgres",
    "password": "tu_password_aqui", # Pon la contraseña que definiste en Docker
    "port": "5432"
}

def get_connection():
    return psycopg2.connect(**DB_CONFIG)

# --- FUNCIONES DE BASE DE DATOS (Mapeo con tu esquema SQL) ---

def get_or_create_stadium(cursor, name, city=None):
    cursor.execute('SELECT id FROM "Stadium" WHERE name = %s', (name,))
    row = cursor.fetchone()
    if row: return row[0]
    
    cursor.execute('''INSERT INTO "Stadium" (name, city, has_roof) 
                      VALUES (%s, %s, %s) RETURNING id''', (name, city, False))
    return cursor.fetchone()[0]

def get_or_create_team(cursor, name, stadium_id=None):
    cursor.execute('SELECT id FROM "Team" WHERE name = %s', (name,))
    row = cursor.fetchone()
    if row: return row[0]
    
    cursor.execute('''INSERT INTO "Team" (name, home_stadium_id) 
                      VALUES (%s, %s) RETURNING id''', (name, stadium_id))
    return cursor.fetchone()[0]

def get_or_create_competition(cursor, name, season):
    # Asumimos que la Nación 'England' tiene ID 1 (puedes crear una función para esto)
    cursor.execute('SELECT id FROM "Competition" WHERE name = %s AND season = %s', (name, season))
    row = cursor.fetchone()
    if row: return row[0]
    
    cursor.execute('''INSERT INTO "Competition" (name, season, competition_type) 
                      VALUES (%s, %s, %s) RETURNING id''', (name, season, 'League'))
    return cursor.fetchone()[0]

def insert_match_data(conn, match_info):
    """
    Función principal que inserta un partido y sus relaciones
    """
    with conn.cursor() as cur:
        # 1. Preparar Entorno
        id_stadium = get_or_create_stadium(cur, match_info['stadium_name'])
        id_comp = get_or_create_competition(cur, match_info['comp_name'], "2024/2025")
        
        # En tu SQL, Leg es obligatorio. Creamos uno por defecto si no existe.
        cur.execute('INSERT INTO "Leg" (name) VALUES (%s) ON CONFLICT DO NOTHING', ('Regular Season',))
        cur.execute('SELECT id FROM "Leg" WHERE name = %s', ('Regular Season',))
        id_leg = cur.fetchone()[0]

        # 2. Equipos
        id_home = get_or_create_team(cur, match_info['home_name'], id_stadium)
        id_away = get_or_create_team(cur, match_info['away_name'])

        # 3. Partido (Match)
        cur.execute('''INSERT INTO "Match" (competition_id, stadium_id, leg_id, match_date, match_time, attendance) 
                       VALUES (%s, %s, %s, %s, %s, %s) RETURNING id''', 
                    (id_comp, id_stadium, id_leg, match_info['date'], match_info['time'], match_info['attendance']))
        id_match = cur.fetchone()[0]

        # 4. Team_Game (Estadísticas por equipo en ese partido)
        # Local
        cur.execute('''INSERT INTO "Team_Game" (team_id, match_id, is_home, final_score, goals_scored, goals_conceded) 
                       VALUES (%s, %s, %s, %s, %s, %s)''', 
                    (id_home, id_match, True, match_info['score'], match_info['goals_h'], match_info['goals_a']))
        
        # Visitante
        cur.execute('''INSERT INTO "Team_Game" (team_id, match_id, is_home, final_score, goals_scored, goals_conceded) 
                       VALUES (%s, %s, %s, %s, %s, %s)''', 
                    (id_away, id_match, False, match_info['score'], match_info['goals_a'], match_info['goals_h']))
        
        conn.commit()
        print(f"Éxito: {match_info['home_name']} vs {match_info['away_name']} guardado.")

# --- LÓGICA DE EXTRACCIÓN (SCRAPER) ---

def scrape_and_save():
    ua = UserAgent()
    header = {'User-Agent': str(ua.random)}
    conn = get_connection()

    # Ejemplo para un partido específico (esto iría dentro de tu bucle de meses)
    match_web_id = "147018" 
    url = f"https://southern-football-league.co.uk/match/m/{match_web_id}/squad/"
    
    try:
        response = requests.get(url, headers=header)
        soup = BeautifulSoup(response.content.decode('utf-8', errors='ignore'), 'lxml')

        # --- Extracción de datos (Basado en la estructura del Notebook) ---
        badges = soup.find_all(class_='badge')
        home_name = badges[0].find_next('div').text.strip()
        away_name = badges[1].find_next('div').text.strip()
        
        score_text = soup.find(class_='score-xs').text.strip() # "2 - 1"
        g_h, g_a = score_text.split('-')

        # Datos extra (Stadium, Attendance, etc)
        # Nota: Estos selectores dependen del HTML real de la web
        stadium_raw = soup.find(string=re.compile("Stadium:")).parent.text.replace("Stadium:", "").strip()
        
        match_data = {
            'comp_name': "Southern League Premier Central",
            'home_name': home_name,
            'away_name': away_name,
            'score': score_text,
            'goals_h': int(g_h),
            'goals_a': int(g_a),
            'stadium_name': stadium_raw,
            'date': '2024-08-15', # Deberías extraer esto con regex del HTML
            'time': '15:00:00',
            'attendance': 350
        }

        insert_match_data(conn, match_data)

    except Exception as e:
        print(f"Error procesando partido {match_web_id}: {e}")
    finally:
        conn.close()

if __name__ == "__main__":
    scrape_and_save()