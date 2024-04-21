SELECT EventName, EventDate
FROM tblEvent
ORDER BY EventDate DESC;

SELECT TOP 5 EventName as What,EventDetails as Details
FROM tblEvent
ORDER BY EventDate DESC;

SELECT TOP 3 CategoryID, CategoryName
FROM tblCategory
ORDER BY CategoryName DESC;


SET NOCOUNT ON

SELECT TOP 2 EventName AS 'What', EventDate AS 'When'
FROM
	tblEvent 
ORDER BY EventDate 

SELECT TOP 2 EventName AS 'What',EventDate AS 'When'
FROM tblEvent
ORDER BY EventDate DESC;

SELECT EventName, EventDate
FROM tblEvent
where CategoryID = 11
ORDER BY EventDate;

SELECT EventName AS 'What', EventDate AS 'When'
FROM tblEvent
WHERE EventDate between '20050201' and '20050228'

SELECT EventName,EventDetails, EventDate
FROM tblEvent 
where CategoryID = 4 or  Eventdetails like '%Water%' or countryID in (8,22,30,35) and EventDate >= '19700101'

SELECT EventName, EventDate
FROM tblEvent
where EventName like '%Teletubbies%' or EventName like '%Pandy%'

SELECT EventName AS What, EventDetails AS Details, EventDate AS 'When'
FROM tblEvent
WHERE CategoryID <> 14 and EventDetails like '%train%'

SELECT EventName AS What,EventDetails AS Details, EventDate AS 'When'
FROM tblEvent
WHERE CountryID = 13 and EventDetails not like '%space%' and EventName not like '%space%'


SELECT EventName, EventDetails
FROM tblEvent
WHERE CategoryID in (5,6) and  EventDetails not like '%death%' and  EventDetails not like '%war%'

SELECT EventName,LEN(EventName) AS 'Length of name'
FROM tblEvent
ORDER BY 'Length of Name' ASC

SELECT
	c.CountryName, 
	CASE 
		WHEN c.ContinentID = 3 THEN 'Europe'
		WHEN c.ContinentID in (5,6) THEN 'Americas'
		WHEN c.ContinentID in (2,4) THEN 'Somewhere hot'
		WHEN c.ContinentID = 7 THEN 'Somewhere cold'
		WHEN c.ContinentID = 1 THEN 'Asia'
		ELSE 'Somewhere else'
	END AS CountryLocation

FROM
	tblCountry AS c
ORDER BY CountryLocation DESC

SELECT
	c.Country,
	c.KmSquared,
	
	-- the number of times the Wales area divided the country area
	(c.KmSquared - c.KmSquared % 20761) / 20761 AS WalesUnits,

	-- divide area of country by area of Wales, and the % operator leaves remainder
	c.KmSquared % 20761 AS AreaLeftOver,

	CASE	
		WHEN c.KmSquared < 20761 THEN 'Smaller than Wales'
		ELSE CAST((c.KmSquared - c.KmSquared % 20761) / 20761 as varchar(100)) +
			' x Wales plus ' +
			CAST(c.KmSquared % 20761 AS varchar(100)) +
			' sq. km.'
	END as WalesComparison


FROM
	CountriesByArea AS c
ORDER BY
	-- order by closeness in size to Wales
	ABS(20761-c.KmSquared) ASC


SELECT
	e.EventName + 
		' (category ' + 
		CAST(e.CategoryID AS varchar(100)) +
		')' AS 'Event (category)',

	e.EventDate
FROM
	tblEvent AS e
WHERE
	e.CountryID = 1

SELECT
	c.ContinentName,
	c.Summary,
	IsNull(c.Summary,'No summary') AS 'Using ISNULL',
	COALESCE(c.Summary,'No summary') AS 'Using COALESCE',
	CASE
		WHEN c.Summary is null THEN 'No summary'
		ELSE c.Summary
	END AS 'Using CASE'

FROM
	tblContinent as c


SELECT
	e.EventName,
	e.EventDate AS NotFormatted,
	FORMAT(e.EventDate, 'dd/MM/yyyy') AS UsingFormat,
	CONVERT(char(10),e.EventDate,103) AS UsingConvert

FROM
	tblEvent AS e
WHERE
	year(e.EventDate) = 1978
ORDER BY	
	e.EventDate


SELECT
	e.EventName,
	FORMAT(e.EventDate,'dd MMM yyyy') AS 'Event date',

	-- difference in days
	DateDiff(day,e.EventDate,'19640304') AS 'Days offset',

	-- number of days from birthday
	ABS(
		DateDiff(day,e.EventDate,'19640304')
	) AS 'Days difference'
FROM
	tblEvent AS e
ORDER BY
	-- show closest events first
	'Days difference' ASC

SELECT
	e.EventName,

	-- the date
	FORMAT(e.EventDate,'dddd dd MMMM, yyyy') AS 'When',

	-- the day of the week
	DateName(weekday,e.EventDate) AS 'Day of week',

	-- the day number
	day(e.EventDate) AS 'Day number'
FROM
	tblEvent AS e
WHERE
	-- limit to Friday 13th
	DateName(weekday,e.EventDate) = 'Friday' and
	day(e.EventDate) = 13;

SELECT
	f.Title,
	s.Source
FROM 
	Film  f

	-- link to the table of sources for each film
	JOIN Source s ON f.SourceID = s.SourceID
WHERE
	-- show the ones where the source is NA
	s.Source = 'NA'
ORDER BY
	f.Title

	SELECT
	e.EventName,
	e.EventDate,
	c.CategoryName

FROM
	tblCategory  c

	INNER JOIN tblEvent  e
		on C.CategoryID = e.CategoryID

ORDER BY
	e.EventDate DESC


	SELECT

	ep.Title, 
	en.EnemyName,
	a.AuthorName

FROM
	tblAuthor  a
	INNER JOIN tblEpisode  ep ON a.AuthorId = ep.AuthorId
	INNER JOIN tblEpisodeEnemy  ee ON ep.EpisodeId = ee.EpisodeId
	INNER JOIN tblEnemy  en ON ee.EnemyId = en.EnemyId

WHERE
	en.EnemyName like '%Dalek%'


	SELECT     

	cy.CountryName AS Country, 
	ev.EventName AS [What happened], 
	ev.EventDate AS [When happened]

FROM       
	tblCountry  cy
	INNER JOIN tblEvent  ev
	ON cy.CountryID = ev.CountryID

ORDER BY [When happened];

WITH ImportantPeople AS (
	SELECT 
		PersonId
	FROM
		tblPerson AS p
	WHERE
		(
			SELECT COUNT(*) 
			FROM tblDelegate AS d
			WHERE d.PersonId=p.PersonId
		) >= 6
)

-- now get a list of all of the courses these people have booked
SELECT DISTINCT
	c.CourseName,
	d.DelegateId,
	p.PersonId	
FROM
	tblCourse AS c
	INNER JOIN tblSchedule AS s ON c.CourseId=s.CourseId
	INNER JOIN tblDelegate AS d ON s.ScheduleId=d.ScheduleId
	INNER JOIN ImportantPeople AS p ON d.PersonId=p.PersonId;


	WITH ImportantPeople AS (
	SELECT 
		PersonId
	FROM
		tblPerson AS p
	WHERE
		(
			SELECT COUNT(*) 
			FROM tblDelegate AS d
			WHERE d.PersonId=p.PersonId
		) >= 6
)

-- now get a list of all of the courses these people have booked
SELECT DISTINCT
	c.CourseName,
	d.DelegateId,
	p.PersonId	
FROM
	tblCourse AS c
	INNER JOIN tblSchedule AS s ON c.CourseId=s.CourseId
	INNER JOIN tblDelegate AS d ON s.ScheduleId=d.ScheduleId
	INNER JOIN ImportantPeople AS p ON d.PersonId=p.PersonId


	USE Movies
GO

-- select all of the films made by Spielberg
WITH SpielbergFilms AS (
	SELECT
		f.FilmId,
		f.FilmName
	FROM
		tblFilm AS f
		INNER JOIN tblDirector AS d ON f.FilmDirectorId=d.DirectorId
	WHERE
		d.DirectorName LIKE '%Spielberg%'
) 

-- link to this CTE to show all of the actors who have appeared
-- in Spielberg films
SELECT 
	a.ActorName,
	s.FilmName,
	c.CastCharacterName
FROM
	SpielbergFilms AS s
	INNER JOIN tblCast AS c ON s.FilmId=c.CastFilmId	
	INNER JOIN tblActor AS a ON c.CastActorId=a.ActorId
ORDER BY
	ActorName;


ALTER PROC spDecade(
	@dob date = '19250101'
)

AS

-- get start and end of decade
DECLARE @StartYear int = year(@dob) - year(@dob) % 10

-- accumulate list of events in this decade
DECLARE @Events varchar(max) = ''
SELECT
	@Events = @Events + 

	-- usually need a separating comma
	CASE 
		WHEN len(@Events) > 0 THEN ','
		ELSE ''
	END + 

	-- add on this event name
	QUOTENAME(e.EventName,'''')

FROM
	tblEvent AS e
WHERE
	year(e.EventDate) between @StartYear and @StartYear + 9

-- now build up SQL to list these events
DECLARE @sql varchar(max) = 'SELECT * FROM tblEvent WHERE EventName IN (' + @Events + ')'

EXEC (@sql)
GO

spDecade;



create or ALTER PROC spEpisodesSorted(
	@SortColumn varchar(100) = 'SeriesNumber',
	@SortOrder varchar(100) = 'ASC'
)
AS

-- list out episodes using specific sort order and dynamic SQL
DECLARE @sql varchar(max) = 
	'SELECT * FROM tblEpisode ORDER BY ' +
	@Sortcolumn + ' ' + @SortOrder

-- run command contained in variable
EXEC(@sql)

GO

-- show episodes in default order
spEpisodesSorted 
GO

-- show episodes in reverse title order
spEpisodesSorted 'Title', 'DESC'
;


WITH Episodes AS (

	-- get the year and series number for each episode
	SELECT 
		year(e.EpisodeDate) AS EpisodeYear,
		e.SeriesNumber,
		e.EpisodeId
	FROM
		TBLEpisode AS e
)

SELECT * FROM Episodes
PIVOT (
	COUNT(Episodeid)
	FOR SeriesNumber IN (
		[1],[2],[3],[4],[5])
) AS PivotTable
;
DECLARE @ColumnList varchar(max) = ''

-- accumulate the episode types
SELECT 
	@ColumnList += 
		CASE
			WHEN LEN(@ColumnList) = 0 THEN ''
			ELSE ','
		END + QUOTENAME(LEFT(e.EpisodeType,CHARINDEX(' ',e.EpisodeType,1)-1))
FROM
	tblEpisode AS e
GROUP BY
	e.EpisodeType
ORDER BY
	e.EpisodeType

-- show this worked!
-- SELECT @ColumnList

DECLARE @sql varchar(max) = 'WITH Episodes AS (

	-- get the episode type and the 
	-- doctor for each episode
	SELECT 
		LEFT(e.EpisodeType,CHARINDEX('' '',e.EpisodeType,1)-1) AS EpisodeType,
		d.DoctorName,
		e.EpisodeId
	FROM
		tblEpisode AS e
		INNER JOIN tblDoctor AS d
			 ON e.DoctorId = d.DoctorId
)

SELECT * FROM Episodes
PIVOT (
	COUNT(Episodeid)
	FOR EpisodeType IN (' + @ColumnList + 
		')
) AS PivotTable'

EXEC(@sql)
;



CREATE TRIGGER trgEventMonitor
ON tblEvent
INSTEAD OF DELETE
AS
BEGIN

	-- don't let anyone delete an event
	DECLARE @CountryId int
	DECLARE @EventId int

	SELECT 
		@CountryId = d.CountryID,
		@EventId = D.EventID
	FROM 
		deleted AS d

	-- if country is not UK (7), allow deletion
	IF @CountryId <> 7 
		BEGIN
			DELETE 
			FROM tblEvent
			WHERE EventId = @EventId
		END

END;


CREATE TABLE tblCountryChanges(
	CountryName varchar(100),
	Change varchar(100)
)

GO

-- trigger to capture previous and new country name
CREATE TRIGGER trgCountryUpdate
ON tblCountry
AFTER UPDATE
AS

BEGIN

	-- capture previous name
	INSERT INTO tblCountryChanges(
		CountryName,
		Change
	)
	SELECT d.CountryName, 'Previous name'
	FROM deleted AS d

	-- get new name
	INSERT INTO tblCountryChanges(
		CountryName,
		Change
	)
	SELECT i.CountryName, 'New name'
	FROM inserted AS i

END
GO

-- now create trigger to cope with country deletion
CREATE TRIGGER trgCountryDelete
ON tblCountry
AFTER DELETE
AS
BEGIN

	-- store deleted country
	INSERT INTO tblCountryChanges(
		CountryName,
		Change
	)
	SELECT d.CountryName, 'Deleted'
	FROM deleted AS d

END
GO

-- finally create trigger to cope with country insertion
CREATE TRIGGER trgCountryInsert
ON tblCountry
AFTER INSERT
AS
BEGIN

	-- store inserted country
	INSERT INTO tblCountryChanges(
		CountryName,
		Change
	)
	SELECT i.CountryName, 'Inserted'
	FROM inserted AS i

END




	









END
	
