/*Find the 5 oldest instagram users?*/
SELECT * FROM users
ORDER BY created_at
LIMIT 5;


/*Which day do most users register on?*/
SELECT 
	DAYNAME(created_at) AS day, COUNT(id) AS Total_Registration
FROM
    users
GROUP BY day
ORDER BY Total_Registration DESC;

/* Find the user who have never posted images?*/
SELECT 
    username
FROM
    users
        LEFT JOIN
    photos ON users.id = photos.user_id
WHERE
    photos.id IS NULL;
 
 /* Other Approch */
 
SELECT 
    username
FROM
    users
    WHERE id NOT IN (select photos.user_id FROM photos
		GROUP BY photos.user_id)


/*Find the average no of photo per user (total number of photos/total number of users)?*/

SELECT 
    ROUND((SELECT COUNT(id)
                FROM
                    photos) / (SELECT COUNT(id) FROM users), 2) AS Average_poto_per_user;
            
            
            
/*Find the most likes on a single photo?*/

SELECT photos.user_id, users.username, likes.photo_id, photos.image_url, date(photos.created_dat) AS Photo_Creadte_Date, COUNT(likes.user_id) AS No_of_Likes 
FROM likes
	JOIN
	photos ON photos.id = likes.photo_id 
		JOIN
		users ON users.id = photos.user_id
GROUP BY likes.photo_id
ORDER BY No_of_Likes DESC
LIMIT 1;


/*Rank the users based on the postings (higher to lower).*/

SELECT 
    users.username, COUNT(photos.image_url) AS total
FROM
    users
        JOIN
    photos ON photos.user_id = users.id
GROUP BY users.id
ORDER BY total DESC;


/* Find the top 5 most commonly used hashtags?*/

SELECT 
    tags.tag_name, COUNT(photo_tags.tag_id) AS Counts
FROM
    tags
        JOIN
    photo_tags ON photo_tags.photo_id = tags.id
GROUP BY tags.id
ORDER BY counts DESC;


/*Find users who have liked every single photo on the site (if any)?*/

SELECT 
    users.username, COUNT(users.id) AS total_Likes
FROM
    users
        JOIN
    likes ON users.id = likes.user_id
GROUP BY users.id
HAVING total_Likes = (SELECT 
        COUNT(*)
    FROM
        photos);
        
/*Find users who have never commented on a photo?*/   

SELECT users.id, users.username FROM users
Where users.id NOT IN 
	(SELECT comments.user_id FROM comments
    GROUP BY comments.user_id)
ORDER BY users.id;


/*Find the percentage of our users who have either never commented on a photo or have commented on every photo?*/
SELECT 
    tableA.totalA AS Commented,
    (tableA.totalA / (SELECT 
            COUNT(*)
        FROM
            users)) * 100 AS 'Percentage%',
    tableB.totalB AS NeverCommented,
    (tableB.TotalB / (SELECT 
            COUNT(*)
        FROM
            users)) * 100 AS 'Percentage%'
FROM
    (SELECT 
        COUNT(*) AS totalA
    FROM
        (SELECT 
        users.username, COUNT(users.id) AS totalcomments
    FROM
        users
    JOIN comments ON users.id = comments.user_id
    GROUP BY users.id
    HAVING totalcomments = (SELECT 
            COUNT(*)
        FROM
            photos)) AS Com) AS tableA
        JOIN
    (SELECT 
        COUNT(*) AS totalB
    FROM
        (SELECT 
        users.username, comments.comment_text
    FROM
        users
    LEFT JOIN comments ON users.id = comments.user_id
    GROUP BY users.id
    HAVING comment_text IS NULL) no_com) AS tableB;