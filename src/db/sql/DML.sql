/*
Team 181 - Marina Hampton, Zareeb Lorenzana, & Skyler Santos
Date Updated: 03.18.2024
Citation for the following SQL:
Date: 2/14/2024
Adapted from: 
Source URL: https://canvas.oregonstate.edu/courses/1946034/pages/exploration-database-application-design?module_item_id=23809325
*/

-- DML operations for users
-- ----------------------------------------------

--  * SELECT/SHOW all users and relevant information for the Browse/list users page
SELECT * FROM users;

-- * INSERT: add a new User
INSERT INTO users (username, firstName, lastName, email, phoneNumber, signupDate)
VALUES (:userName, :firstName, :lastName, :email, :phoneNumber, :NOW());

-- * DELETE a User
DELETE FROM users WHERE userID = :userID_selected_from_browse_ManageUser_page;

-- UPDATE a User's data based on submission of the Update User form 
UPDATE users SET firstName = :fnameInput, lastName= :lnameInput, email = :emailInput 
WHERE userID= :userID_from_the_update_form; 


-- DML operations for followers
-- ----------------------------------------------

-- * SELECT/DISPLAY all followers info including username of the followee and follower from users
SELECT
    f.userRelationshipID,
    u1.username AS followeeUsername,
    f.followeeID,
    f.followerID,
    u2.username AS followerUsername,
    f.followedSince
FROM 
    followers f
JOIN 
    users u1 ON f.followeeID = u1.userID
JOIN 
    users u2 ON f.followerID = u2.userID;

-- SELECT to order alphabetically by username
SELECT 
    userID,
    username 
FROM
    users
ORDER BY
    username;

-- * INSERT a follower
INSERT INTO followers (followeeID, followerID, followedSince)
VALUES (:followeeUserID, :followerUserID, NOW());

-- DELETE relationship between two users
DELETE FROM followers WHERE userRelationshipID = :userID_selected_from_browse_ManageFollowers_page

-- DML operations for posts
-- ----------------------------------------------

-- SELECT/DISPLAY all posts and data including userID-username
SELECT
p.postID,
CONCAT(u.userID, '-', u.username) AS 'userID-username',
p.postDate,
p.postBody
FROM posts p
JOIN users u ON p.userID = u.userID;

-- SELECT all users as well as userID-username
SELECT userID, CONCAT(userID, '-', username) AS 'userID-username' FROM users;

-- * INSERT a Post
INSERT INTO posts (userID, postDate, postBody)
VALUES (:userID, NOW(), :postBody);

-- DELETE a post 
DELETE FROM posts WHERE postID = :postID_selected_from_all_Posts_from_ManagePosts;

-- SELECT/Display a users' post including userID and post info and joins posts on users
SELECT 
p.postID, 
p.userID,
CONCAT(u.userID, '-', u.username) AS 'userID-username',
p.postDate,
p.postBody
FROM posts p
JOIN users u ON p.userID = u.userID
WHERE postID = :postID_selected_from_all_Posts_from_ManagePosts;

-- UPDATE post from existing post data
UPDATE 
    posts
SET 
    userID = :userID_selected_from_browse_ManageUser_page,
    postDate = :postDate_selected,
    postBody = :postBody_selected, 
WHERE 
    postID = :postID_selected_from_all_Posts_from_ManagePosts;

-- DML operations for likes
-- ----------------------------------------------

-- * SELECT/DISPLAY all likes on posts, ID of user who liked the post, and who posted the post
SELECT
    likes.likeID,
    likes.postID,
    users_postedBy.userID,
    users_postedBy.username AS postedBy,
    likes.likedByUserID,
    users_likedBy.username AS likedBy,
    likes.dateLiked
FROM
    likes
JOIN 
    posts ON likes.postID = posts.postID
JOIN 
    users AS users_postedBy ON posts.userID = users_postedBy.userID
LEFT JOIN
    users AS users_likedBy ON likes.likedByUserID = users_likedBy.userID;

-- Gets users data and orders alphabetically for dropdown
SELECT 
    userID, 
    username 
FROM
    users
ORDER BY
    username;

-- Gets posts data
SELECT 
    postID 
FROM 
    posts 
ORDER BY 
    postID;

-- DELETE like
DELETE FROM likes WHERE likeID = :likeID_selected_from_ManageLikes_page;

-- SELECT data from likes on a post, including usernames of who posted and liked the post
SELECT
    likes.likeID,
    likes.postID,
    users_postedBy.userID,
    users_postedBy.username AS postedBy,
    likes.likedByUserID,
    users_likedBy.username AS likedBy,
    likes.dateLiked
FROM
    likes
JOIN 
    posts ON likes.postID = posts.postID
JOIN 
    users AS users_postedBy ON posts.userID = users_postedBy.userID
LEFT JOIN
    users AS users_likedBy ON likes.likedByUserID = users_likedBy.userID
WHERE 
    likeID = :likeID_selected_from_ManageLikes_page;

-- * INSERT new data for likes
INSERT INTO likes (postID, likedByUserID, dateLiked)
VALUES (:postID, :likedByUserID, NOW());

-- -- * UPDATE likes table to set likedByUserID to NULL when user is deleted
-- UPDATE likes
-- SET likedByUserID = NULL
-- WHERE likedByUserID = :userID_to_delete;

-- * UPDATE/ edit existing likes data
UPDATE 
    likes
SET 
    postID = :postID_selected_from_all_from_manage_likes,
    likedByUserID = :userName_selected_from_dropdown_all_userNames,
    dateLiked = :existing_date_from_manage_likes_page;                   
WHERE 
    likeID = :likeID_from_manage_likes_page;

-- DML operations for tags and postHasTags (postHasTags and tags are on the same page)
-- ----------------------------------------------

-- * SELECT/DISPLAY all data for Manage Post's Tags table
SELECT
    p.postTagID,
    p.tagID,
    t.tag,
    p.postID,
    p.dateTagged
FROM
    postsHasTags AS p
JOIN 
    tags AS t ON p.tagID = t.tagID
JOIN 
    posts ON p.postID = posts.postID;

-- * INSERT a new record in postHasTags (Manage Post's Tags)
INSERT INTO 
postHasTags (postTagID, tagID, postID, dateTagged)
VALUES (:selected_postTagID, :selectedTag, :selectedPostID, :selectedDate);

-- * DELETE a record from postsHasTags/ a relationship between a Post and Tag
DELETE FROM postsHasTags WHERE postTagID = :postTagID_selected_from_ManagePosts_Tags;


-- DML operations for tags (same page as postsHasTags)
-- ---------------------------------------------

-- SELECT / display all tags alphabetically 
SELECT * from tags
ORDER BY tag

-- DELETE a tag
DELETE FROM tags 
WHERE tagID = :tagID_selected_from_tags;

-- INSERT a tag
INSERT INTO tags
VALUES (:tag_entered_by_user);
