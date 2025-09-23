USE netflix;

-- PARTE 1
-- 1. ¿Cuántos títulos existen en el catálogo?
SELECT COUNT(*) AS total_titulos
FROM shows;

-- 2. ¿Cuántos tipos de contenido diferentes hay registrados (Movie, TV Show, etc.)?
SELECT COUNT(*) AS total_tipos
FROM ShowType;

-- 3. ¿Cuántos países distintos están representados en las producciones?
SELECT COUNT(DISTINCT name) AS total_paises
FROM Country;

-- 4. ¿Cuántas clasificaciones de edad (rating) diferentes existen?
SELECT COUNT(*) AS total_ratings
FROM Rating;

-- PARTE 2
-- 5. ¿Cuál es el país con mayor cantidad de títulos disponibles en el catálogo?
SELECT c.name AS pais, COUNT(sc.show_id) AS total_titulos
FROM show_country sc
INNER JOIN Country c ON sc.country_id = c.country_id
GROUP BY c.name
ORDER BY total_titulos DESC
LIMIT 1;

-- 6. ¿Cuáles son los 5 géneros más frecuentes en el catálogo?
SELECT g.name AS genero, COUNT(sg.show_id) AS total_titulos
FROM show_genre sg
INNER JOIN Genre g ON sg.genre_id = g.genre_id
GROUP BY g.name
ORDER BY total_titulos DESC
LIMIT 5;

-- 7. ¿Qué clasificación por edad (rating) es la más común en las películas y cuál en las series?
SELECT st.name AS tipo_contenido, r.code AS rating, COUNT(s.show_id) AS total
FROM shows s
INNER JOIN ShowType st ON s.type_id = st.type_id
INNER JOIN Rating r ON s.rating_id = r.rating_id
GROUP BY st.name, r.code
ORDER BY st.name, total DESC;

-- 8. ¿Cómo ha cambiado la duración promedio de las películas a lo largo de los años?
-- Usamos REGEXP_SUBSTR para extraer solo el número de minutos
SELECT s.release_year, 
       AVG(CAST(REGEXP_SUBSTR(s.duration, '^[0-9]+') AS UNSIGNED)) AS duracion_promedio
FROM shows s
INNER JOIN ShowType st ON s.type_id = st.type_id
WHERE st.name = 'Movie'
GROUP BY s.release_year
ORDER BY s.release_year;

-- 9. ¿Qué país tiene la mayor diversidad de géneros distintos en su catálogo?
SELECT c.name AS pais, COUNT(DISTINCT sg.genre_id) AS generos_distintos
FROM show_country sc
INNER JOIN Country c ON sc.country_id = c.country_id
INNER JOIN show_genre sg ON sc.show_id = sg.show_id
GROUP BY c.name
ORDER BY generos_distintos DESC
LIMIT 1;

-- 10. ¿Cuál es el título más antiguo disponible en la plataforma? (Usando subquery)
SELECT title, release_year
FROM shows
WHERE release_year = (SELECT MIN(release_year) FROM shows);


-- PREGUNTAS (PROPUESTAS Y PROPIAS) 

-- Pregunta Personal - BURGOS ZORRILLA JOSHUA GABRIEL
-- ¿Cómo ha evolucionado la cantidad de Películas y Series a lo largo del tiempo?
SELECT release_year,
       SUM(CASE WHEN st.name = 'Movie' THEN 1 ELSE 0 END) as peliculas,
       SUM(CASE WHEN st.name = 'TV Show' THEN 1 ELSE 0 END) as series
FROM shows s
INNER JOIN ShowType st ON s.type_id = st.type_id
GROUP BY release_year
HAVING release_year >= 2000
ORDER BY release_year;

-- Pregunta Personal - MORENO SANCHEZ JULIO CESAR
-- ¿Cuál es el título más reciente agregado al catálogo?
SELECT 
    s.title,
    s.date_added
FROM shows s
WHERE s.date_added = (SELECT MAX(date_added) FROM shows);

-- Pregunta Personal - CONTRERAS RIVADENEIRA RICARDO ANDRES
-- ¿Puedes mostrar las películas y series según su país de origen?
SELECT * from Country AS Co; SELECT * FROM shows AS Sh; SELECT * FROM Genre AS Ge; SELECT * FROM ShowType AS ST; SELECT name FROM ShowType; SELECT * FROM show_country;
SELECT Co.name AS Pais,
    Sh.title AS Titulo,
    ST.name AS Tipo
FROM shows AS Sh
JOIN show_country AS SC ON Sh.show_id = SC.show_id
JOIN Country AS Co ON SC.country_id = Co.country_id
JOIN ShowType AS ST ON ST.type_id = Sh.type_id
ORDER BY Pais, Tipo, Titulo;

-- Pregunta Personal - CUESTA BORBOR VÍCTOR MANUEL
-- ¿cuales y cuantos países tienen películas registradas en el catálogo de Netflix?
-- cuantos
SELECT count( distinct c.name) as CantidadPaises
FROM shows sh
INNER JOIN show_country sc on sc.show_id = sh.show_id
INNER JOIN Country c on c.country_id = sc.country_id
INNER JOIN show_genre sg on sg.show_id = sc.show_id
INNER JOIN Genre g on g.genre_id = sg.genre_id
INNER JOIN ShowType st on st.type_id = sh.type_id
WHERE st.name = 'Movie';
-- cuales
SELECT c.name as PAISES
FROM shows sh
INNER JOIN show_country sc on sc.show_id = sh.show_id
INNER JOIN Country c on c.country_id = sc.country_id
INNER JOIN show_genre sg on sg.show_id = sc.show_id
INNER JOIN Genre g on g.genre_id = sg.genre_id
INNER JOIN ShowType st on st.type_id = sh.type_id
WHERE st.name = 'Movie'
GROUP BY c.name;

-- Pregunta Personal - DAYANA DANIELA HERRERA PONCE
-- ¿Cuál es la clasificación de edad con más títulos en Netflix?
SELECT r.code AS rating, COUNT(s.show_id) AS total_titulos
FROM shows s
INNER JOIN Rating r ON s.rating_id = r.rating_id
GROUP BY r.code
ORDER BY total_titulos DESC
LIMIT 1;