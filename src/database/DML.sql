/*
Team 181 - Marina Hampton and Zareeb Lorenzana - DML.sql 
* = required
** = QoL 
Date Updated: 02.23.2024
Citation for the following SQL:
Date: 2/14/2024
Adapted from: 
Source URL: https://canvas.oregonstate.edu/courses/1946034/pages/exploration-database-application-design?module_item_id=23809325
*/

-- DML operations for Users

--  * SELECT/SHOW all Users and relevant information for the Browse/list Users page
SELECT * FROM Users;

-- * INSERT: add a new User
INSERT INTO Users (username, firstName, lastName, email, phoneNumber, signupDate)
VALUES (:userName, ;firstName, :lastName, :email, :phoneNumber, :NOW());


-- ** get a single User's data for the Update User's form - edit button - will auto populate on form
SELECT 
    userID,
    username,
    firstName,
    lastName,
    email,
    phoneNumber,
    signupDate
FROM Users 
WHERE userID = :userID_selected_from_browse_Users_page;

-- get all Users and their userID, firstName, lastName to populate a dropdown to show Users who have a Post 
-- SELECT DISTINCT Users.userID, Users.firstName, Users.lastName
-- FROM
--     Users
-- JOIN
--     Posts ON Users.userID = Posts.userID;

-- update a User's data based on submission of the Update User form 
UPDATE Users SET firstName = :fnameInput, lastName= :lnameInput, email = :emailInput 
WHERE userID= :userID_from_the_update_form; 

-- * delete a User
DELETE FROM Users WHERE userID = :userID_selected_from_browse_User_page;



-- DML operations for Followers
-- ----------------------------------------------

-- * INSERT a follower
INSERT INTO Followers (followeeID, followerID, followedSince)
VALUES (:followeeUserID, :followerUserID, NOW());

-- * SELECT/DISPLAY all Followers info
SELECT * FROM Follwers; 

-- ** Get all Users and their Followers with their IDs and names to populate the User and their Followers dropdown.
SELECT Users.userID, Users.firstName, Users.lastName, Followers.followerID
FROM
    Users
LEFT JOIN
    Followers ON Users.userID = Followers.followeeID;



-- DML operations for Posts
-- ----------------------------------------------

-- SELECT/DISPLAY all Posts and data
SELECT * FROM Posts;

-- * INSERT a Post
INSERT INTO Posts (userID, postDate, postBody)
VALUES (:userID, NOW(), :postBody);

-- ** show all Posts data as well Likes and Tags for list all Posts page 
SELECT
    P.postID,
    P.userID,
    P.postDate,
    P.postBody,
    GROUP_CONCAT(DISTINCT T.tag) AS tags,
    GROUP_CONCAT(DISTINCT PL.likedByUserID) AS likedByUserID
FROM
    Posts P
LEFT JOIN
    PostsHasTags PT ON P.postID = PT.postID
LEFT JOIN
    Tags T ON PT.tagID = T.tagID
LEFT JOIN
    PostsHasLikes PL ON P.postID = PL.postID
GROUP BY
    P.postID;

--  ** get all Posts from a select User
SELECT Posts.postID, Posts.postDate, Posts.postBody
FROM Posts
INNER JOIN
    Users ON Posts.userID = Users.userID
WHERE
    Users.userID = :userID_selected_from_browse_User_page;

-- delete a Post 
DELETE FROM Posts WHERE postID = :postID_selected_from_all_Posts_from_a_select_User;

-- DML operations for PostsHasLikes (interaction table)
-- ----------------------------------------------

-- * SELECT/DISPLAY all PostsHasLikes
SELECT * FROM PostsHasLikes;

-- * INSERT new data for PostsHasLikes
INSERT INTO PostsHasLikes (postID, likedByUserID, dateLiked)
VALUES (:postID, :likedByUserID, NOW());

-- * UPDATE PostsHasLikes table to set likedByUserID to NULL when User is deleted
UPDATE PostsHasLikes
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


-- DML operations for Tags
-- ----------------------------------------------

-- * SELECT/DISPLAY all data for Tags table
SELECT * FROM Tags;

-- * INSERT a new Tag
INSERT INTO Tags (tag)
VALUES (:tag);

 -- ** get Tags from a selected Post - do we move it? 
SELECT P.*
FROM Posts P
JOIN PostsHasTags PT ON P.postID = PT.postID
JOIN Tags T ON PT.tagID = T.tagID
WHERE T.tagID = :tagID_selected_from_all_Tags_page;

-- ** get all tags a selected User has ever used
SELECT DISTINCT
    T.tag
FROM
    Users U
JOIN
    Posts P ON U.userID = P.userID
JOIN
    PostsHasTags PT ON P.postID = PT.postID
JOIN
    Tags T ON PT.tagID = T.tagID
WHERE
    U.userID = :userID_selected_from_all_Users_page; 

-- DML operations for PostsHasTags
-- ---------------------------------------------

-- * SELECT/DISPLAY show all data for PostsHasTags
SELECT *
FROM PostsHasTags;

-- * INSERT a new relationship between a Post and a Tag
INSERT INTO PostsHasTags (postID, tagID, dateTagged)
VALUES (:postID, :tagID, NOW());

-- DELETE a relationship between a Post and Tag
DELETE FROM PostsHasTags
WHERE postID = :postID_to_delete AND tagID = :tagID_to_delete;