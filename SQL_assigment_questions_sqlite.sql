-- LEVEL 1

-- Question 1: Number of users with sessions
SELECT COUNT(DISTINCT user_id) AS total_users_with_sessions FROM sessions;

-- Question 2: Number of chargers used by user with id 1
SELECT COUNT(DISTINCT charger_id) AS n_chargers_used FROM sessions
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
    COUNT(DISTINCT user_id) AS users_per_charger
FROM sessions
GROUP BY charger_id
HAVING users_per_charger > 1;

-- Question 5: Average session time per charger
SELECT 
    charger_id,
    AVG(JULIANDAY(end_time) - JULIANDAY(start_time)) * 24 * 60 AS avg_session_min
FROM sessions
GROUP BY charger_id;
    
-- LEVEL 3

-- Question 6: Full username of users that have used more than one charger in one day (NOTE: for date only consider start_time)
WITH ChargerDayUser AS 
    (
    SELECT
        u.name || ' ' || u.surname AS full_name,
        COUNT(s.user_id) AS chargers_used_day,
        strftime('%d', s.start_time) AS day
    FROM users u
    INNER JOIN sessions s ON s.user_id = u.id
    GROUP BY day, s.user_id
    HAVING chargers_used_day > 1
    )
SELECT DISTINCT full_name FROM ChargerDayUser;

-- Question 7: Top 3 chargers with longer sessions
SELECT DISTINCT
    charger_id,
    ((JULIANDAY(end_time) - JULIANDAY(start_time)) * 24 * 60) AS longest_session_min
FROM sessions
ORDER BY longest_session_min DESC
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
    COUNT(DISTINCT charger_id) AS ChargerUsed 
FROM sessions
GROUP BY user_id
ORDER BY ChargerUsed DESC
LIMIT 3;


-- LEVEL 4

-- Question 10: Number of users that have used only AC chargers, DC chargers or both
SELECT
    s.user_id,
    SUM(CASE WHEN c.type = 'AC' THEN 1 ELSE 0 END) AS AC_sum,
    SUM(CASE WHEN c.type = 'DC' THEN 1 ELSE 0 END) AS DC_sum
FROM sessions s
INNER JOIN chargers c ON s.charger_id = c.id
GROUP BY s.user_id;

WITH UserCharger AS (
    SELECT
        s.user_id,
        SUM(CASE WHEN c.type = 'AC' THEN 1 ELSE 0 END) AS AC_sum,
        SUM(CASE WHEN c.type = 'DC' THEN 1 ELSE 0 END) AS DC_sum
    FROM sessions s
    INNER JOIN chargers c ON s.charger_id = c.id
    GROUP BY s.user_id
)
SELECT 
    SUM(CASE WHEN AC_sum > 0 AND DC_sum = 0 THEN 1 ELSE 0 END) AS AC_users,
    SUM(CASE WHEN DC_sum > 0 AND AC_sum = 0 THEN 1 ELSE 0 END) AS DC_users,
    SUM(CASE WHEN AC_sum > 0 AND DC_sum > 0 THEN 1 ELSE 0 END) AS BOTH_users
FROM UserCharger;

-- Question 11: Monthly average number of users per charger
WITH UserChargerMonth AS (
    SELECT 
        charger_id,
        COUNT(DISTINCT user_id) AS total_users,
        strftime('%Y-%m', start_time) AS month
    FROM sessions
    GROUP BY month, charger_id
)
SELECT
    charger_id,
    month,
    AVG(total_users) AS avg_users
FROM UserChargerMonth
GROUP BY charger_id, month;

-- Question 12: Top 3 users per charger (for each charger, number of sessions)
SELECT * FROM sessions;
SELECT 
    user_id,
    COUNT(DISTINCT start_time) AS NumSessions
FROM sessions
GROUP BY user_id, charger_id
ORDER BY NumSessions DESC
LIMIT 5;

-- LEVEL 5

-- Question 13: Top 3 users with longest sessions per month (consider the month of start_time)
    
-- Question 14. Average time between sessions for each charger for each month (consider the month of start_time)
