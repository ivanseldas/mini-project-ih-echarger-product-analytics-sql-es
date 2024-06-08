-- LEVEL 1

-- Question 1: Number of users with sessions
SELECT COUNT(DISTINCT user_id) AS total_users_with_sessions FROM sessions;

-- Question 2: Number of chargers used by user with id 1
SELECT COUNT(charger_id) AS n_chargers_used FROM sessions
WHERE user_id = 1;


-- LEVEL 2

-- Question 3: Number of sessions per charger type (AC/DC):
SELECT 
    c.type AS ChargerType,
    COUNT(s.id) AS TotalSessions
FROM chargers c
INNER JOIN sessions s ON s.charger_id = c.id
GROUP BY ChargerType;
         
-- Question 4: Chargers being used by more than one user
SELECT 
    charger_id,
    COUNT(user_id) AS users_per_charger
FROM sessions
GROUP BY charger_id
HAVING users_per_charger > 1;

-- Question 5: Average session time per charger
SELECT 
    charger_id,
    AVG(JULIANDAY(end_time) - JULIANDAY(start_time)) * 24 AS avg_session_hours
FROM sessions
GROUP BY charger_id
ORDER BY avg_session_hours DESC;
    
-- LEVEL 3

-- Question 6: Full username of users that have used more than one charger in one day (NOTE: for date only consider start_time)
WITH ChargerDayUser AS 
    (
    SELECT
        u.name AS name,
        u.surname AS surname,
        COUNT(s.user_id) AS chargers_used_day,
        strftime('%d', s.start_time) AS day
    FROM users u
    INNER JOIN sessions s ON s.user_id = u.id
    GROUP BY day, s.user_id
    HAVING chargers_used_day > 1
    )
SELECT DISTINCT name, surname FROM ChargerDayUser;

-- Question 7: Top 3 chargers with longer sessions
SELECT DISTINCT
    charger_id,
    FIRST_VALUE(JULIANDAY(end_time) - JULIANDAY(start_time)) OVER (PARTITION BY charger_id) AS longest_session_hours
FROM sessions
ORDER BY longest_session_hours DESC
LIMIT 3;

-- Question 8: Average number of users per charger (per charger in general, not per charger_id specifically)
WITH ChargerUser AS (
    SELECT user_id, COUNT(charger_id) AS n_charger_user
    FROM sessions
    GROUP BY user_id
)
SELECT
    AVG(n_charger_user) AS avg_charger_per_user
    FROM ChargerUser;
  
-- Question 9: Top 3 users with more chargers being used
SELECT 
    user_id, 
    COUNT(charger_id) AS ChargerUsed 
FROM sessions
GROUP BY user_id
ORDER BY ChargerUsed DESC
LIMIT 3;


-- LEVEL 4

-- Question 10: Number of users that have used only AC chargers, DC chargers or both
WITH AC AS (
        SELECT DISTINCT
            COUNT(DISTINCT s.user_id) AS AC_users 
        FROM sessions s
        INNER JOIN chargers c ON s.charger_id = c.id
        WHERE c.type = 'AC'
    ),
    DC AS (
        SELECT DISTINCT
            COUNT(DISTINCT s.user_id) AS DC_users
        FROM sessions s
        INNER JOIN chargers c ON s.charger_id = c.id
        WHERE c.type = 'DC'
    ),
    BOTH AS (
        SELECT DISTINCT
            s.user_id
            FROM sessions s
            INNER JOIN chargers c ON s.charger_id = c.id
            GROUP BY s.user_id
            HAVING COUNT(DISTINCT c.type) = 2
    )
SELECT
    AC_users,
    DC_users,
    COUNT(user_id) AS BOTH_users
FROM AC, DC, BOTH;

-- Question 11: Monthly average number of users per charger



-- Question 12: Top 3 users per charger (for each charger, number of sessions)




-- LEVEL 5

-- Question 13: Top 3 users with longest sessions per month (consider the month of start_time)
    
-- Question 14. Average time between sessions for each charger for each month (consider the month of start_time)
