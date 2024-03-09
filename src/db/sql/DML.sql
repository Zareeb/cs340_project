/*
Team 181 - Marina Hampton, Zareeb Lorenzana, & Skyler Santos
* = required
** = QoL 
Date Updated: 02.23.2024
Citation for the following SQL:
Date: 2/14/2024
Adapted from: 
Source URL: https://canvas.oregonstate.edu/courses/1946034/pages/exploration-database-application-design?module_item_id=23809325
*/

-- DML operations for users

--  * SELECT/SHOW all users and relevant information for the Browse/list users page
SELECT * FROM users;

-- * INSERT: add a new User
INSERT INTO users (username, firstName, lastName, email, phoneNumber, signupDate)
VALUES (:userName, :firstName, :lastName, :email, :phoneNumber, :NOW());


-- ** get a single User's data for the Update User's form - edit button - will auto populate on form
SELECT 
    userID,
    username,
    firstName,
    lastName,
    email,
    phoneNumber,
    signupDate
FROM users 
WHERE userID = :userID_selected_from_browse_Users_page;

-- get all users and their userID, firstName, lastName to populate a dropdown to show users who have a Post 
-- SELECT DISTINCT users.userID, users.firstName, users.lastName
-- FROM
--     users
-- JOIN
--     posts ON users.userID = posts.userID;

-- update a User's data based on submission of the Update User form 
UPDATE users SET firstName = :fnameInput, lastName= :lnameInput, email = :emailInput 
WHERE userID= :userID_from_the_update_form; 

-- * delete a User
DELETE FROM users WHERE userID = :userID_selected_from_browse_User_page;



-- DML operations for followers
-- ----------------------------------------------

-- * INSERT a follower
INSERT INTO followers (followeeID, followerID, followedSince)
VALUES (:followeeUserID, :followerUserID, NOW());

-- * SELECT/DISPLAY all followers info
SELECT * FROM Follwers; 

-- ** Get all users and their followers with their IDs and names to populate the User and their followers dropdown.
SELECT users.userID, users.firstName, users.lastName, followers.followerID
FROM
    users
LEFT JOIN
    followers ON users.userID = followers.followeeID;



-- DML operations for posts
-- ----------------------------------------------

-- SELECT/DISPLAY all posts and data
SELECT * FROM posts;

-- * INSERT a Post
INSERT INTO posts (userID, postDate, postBody)
VALUES (:userID, NOW(), :postBody);

-- ** show all posts data as well Likes and tags for list all posts page 
SELECT
    P.postID,
    P.userID,
    P.postDate,
    P.postBody,
    GROUP_CONCAT(DISTINCT T.tag) AS tags,
    GROUP_CONCAT(DISTINCT PL.likedByUserID) AS likedByUserID
FROM
    posts P
LEFT JOIN
    postsHasTags PT ON P.postID = PT.postID
LEFT JOIN
    tags T ON PT.tagID = T.tagID
LEFT JOIN
    likes PL ON P.postID = PL.postID
GROUP BY
    P.postID;

--  ** get all posts from a select User
SELECT posts.postID, posts.postDate, posts.postBody
FROM posts
INNER JOIN
    users ON posts.userID = users.userID
WHERE
    users.userID = :userID_selected_from_browse_User_page;

-- delete a Post 
DELETE FROM posts WHERE postID = :postID_selected_from_all_Posts_from_a_select_User;

-- DML operations for likes
-- ----------------------------------------------

-- * SELECT/DISPLAY all likes
SELECT * FROM likes;

-- * INSERT new data for likes
INSERT INTO likes (postID, likedByUserID, dateLiked)
VALUES (:postID, :likedByUserID, NOW());

-- * UPDATE likes table to set likedByUserID to NULL when user is deleted
UPDATE likes
SET likedByUserID = NULL
WHERE likedByUserID = :userID_to_delete;

-- ** SELECT and show number of likes and likedByUserID of selected Post from dropdown
SELECT 
    (SELECT COUNT(*) 
    FROM Likes 
    WHERE postID = :postID_selected_from_all_Posts_page) AS likes_count,
    (SELECT GROUP_CONCAT(likedByUserID) 
    FROM Likes 
    WHERE postID = :postID_selected_from_all_Posts_page) AS liked_user_ids;


-- DML operations for tags
-- ----------------------------------------------

-- * SELECT/DISPLAY all data for tags table
SELECT * FROM tags;

-- * INSERT a new Tag
INSERT INTO tags (tag)
VALUES (:tag);

 -- ** get tags from a selected Post - do we move it? 
SELECT P.*
FROM posts P
JOIN postsHasTags PT ON P.postID = PT.postID
JOIN tags T ON PT.tagID = T.tagID
WHERE T.tagID = :tagID_selected_from_all_Tags_page;

-- ** get all tags a selected User has ever used
SELECT DISTINCT
    T.tag
FROM
    users U
JOIN
    posts P ON U.userID = P.userID
JOIN
    postsHasTags PT ON P.postID = PT.postID
JOIN
    tags T ON PT.tagID = T.tagID
WHERE
    U.userID = :userID_selected_from_all_Users_page; 

-- DML operations for postsHasTags
-- ---------------------------------------------

-- * SELECT/DISPLAY show all data for postsHasTags
SELECT *
FROM postsHasTags;

-- * INSERT a new relationship between a Post and a Tag
INSERT INTO postsHasTags (postID, tagID, dateTagged)
VALUES (:postID, :tagID, NOW());

-- DELETE a relationship between a Post and Tag
DELETE FROM postsHasTags
WHERE postID = :postID_to_delete AND tagID = :tagID_to_delete;