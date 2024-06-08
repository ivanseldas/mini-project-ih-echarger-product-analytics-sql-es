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
    (JULIANDAY(end_time) - JULIANDAY(start_time)) * 24 AS total_hours
FROM sessions;
    
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

-- Question 8: Average number of users per charger (per charger in general, not per charger_id specifically)

-- Question 9: Top 3 users with more chargers being used




-- LEVEL 4

-- Question 10: Number of users that have used only AC chargers, DC chargers or both

-- Question 11: Monthly average number of users per charger

-- Question 12: Top 3 users per charger (for each charger, number of sessions)




-- LEVEL 5

-- Question 13: Top 3 users with longest sessions per month (consider the month of start_time)
    
-- Question 14. Average time between sessions for each charger for each month (consider the month of start_time)
