SELECT * FROM netflix;

--4. Find the top 5 countries with the most content on netflix
SELECT 
    UNNEST(STRING_TO_ARRAY(country,',')) as new_country,
	COUNT(show_id) as total_content
FROM netflix
GROUP BY new_country
ORDER BY total_content DESC
LIMIT 5

--5. Identify the longest movie?
SELECT * FROM netflix
WHERE
    type = 'Movie'
    AND 
	duration = (SELECT MAX(duration) from netflix)

--6.Find content added in last 5 years
SELECT *
FROM netflix
WHERE TO_DATE(date_added,'Month DD,YYYY') >= CURRENT_DATE - INTERVAL '5 years'

--7.Find all the movies /TV Shows by director 'Rajiv Chilaka'
SELECT * FROM netflix
where 
	director = 'Rajiv Chilaka'

--8.List all TV Shows with more than 5 seasons
SELECT *
    --SPLIT_PART(duration, ' ',1) as sessions
 FROM netflix
WHERE 
    type = 'TV Show'
	AND
	SPLIT_PART(duration, ' ',1):: numeric > 5 

--9. Count the number of content items in each genre
SELECT
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) as GENRE,
	COUNT(show_id) as total_content
FROM netflix	
    GROUP BY GENRE

--10. Find each year and the average number of content release by India on netflix, 
--return top 5 year with highest average content release!
SELECT 
    EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD,YYYY')) as year,
	COUNT(*) as yearly_content,
	ROUND(
	COUNT(*):: numeric/(SELECT COUNT(*) FROM netflix WHERE country = 'India'):: numeric * 100  
	,2) as avg_content_per_year
    
FROM netflix
where 
    country = 'India'
GROUP BY year
--11. List all movies that are documentaries
SELECT * FROM netflix
WHERE 
    type = 'Movie'
	AND
	listed_in = 'Documentaries'

--12. Find all content without a director
SELECT * FROM netflix
WHERE director IS NULL

--13. Find how  many movies actor 'Salman Khan' appeared in last 10 years!
SELECT * FROM netflix
WHERE 
    casts ILIKE '%Salman Khan%' 
    AND 
    release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10

--14. Find the top 10 actors who have appeared in the highest number of movies 
--produced in INDIA
SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) as actors,
	COUNT(*) as total_content
FROM netflix
WHERE country ILIKE '%India'
GROUP BY actors
ORDER BY total_content DESC
LIMIT 10

--15.Categorize the content based on the presence of the keyword 
--'Kill' and 'violence' in the description field.Label content containing 
--these keywords as 'Bad' and all other content as 'Good'.Count
--how many items fall into each category
WITH new_table
AS
(
SELECT 
*,
    CASE
	WHEN
	    description ILIKE '%kill%' OR
		description ILIKE '%violence%' THEN 'Bad_Content'
		ELSE 'Good_Content'
    END category
FROM netflix
)
SELECT 
    category,
	COUNT(*) as total_content
FROM new_table
GROUP BY category
	
	
		



