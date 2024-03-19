/*
Team 181 - Marina Hampton, Zareeb Lorenzana, & Skyler Santos
DDL.SQL - hand authored
Database of Simple Social App
Date Updated: 03.18.2024
*/

SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT = 0;

DROP TABLE IF EXISTS users;
-- records the details of users of the app
CREATE TABLE users (
    userID INT(11) AUTO_INCREMENT NOT NULL,
    username VARCHAR(20) NOT NULL UNIQUE,
    firstName VARCHAR(255) NOT NULL,
    lastName VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phoneNumber VARCHAR(15) NOT NULL UNIQUE,
    signupDate DATE NOT NULL,
    PRIMARY KEY (userID)
);

DROP TABLE IF EXISTS posts;
-- records the details of a user’s posts
CREATE TABLE posts (
    postID INT(11) AUTO_INCREMENT NOT NULL,
    userID INT(11) NOT NULL ,
    postDate DATE NOT NULL,
    postBody VARCHAR(255) NOT NULL,
    PRIMARY KEY (postID),
    FOREIGN KEY (userID) REFERENCES users (userID) ON DELETE CASCADE
);

DROP TABLE IF EXISTS postsHasTags;
-- Interaction table postsHasTags between posts and tags;
CREATE TABLE postsHasTags (
    postTagID INT(11) AUTO_INCREMENT NOT NULL,
    postID INT(11) NOT NULL,
    tagID INT(11) NOT NULL,
    dateTagged DATE NOT NULL, 
    PRIMARY KEY (postTagID),
    UNIQUE (postID, tagID),
    FOREIGN KEY (postID) REFERENCES posts (postID) ON DELETE CASCADE,
    FOREIGN KEY (tagID) REFERENCES tags (tagID) ON DELETE CASCADE
);

DROP TABLE IF EXISTS tags;
-- tags : Allows users to create tags and organize their posts based on type of content
CREATE TABLE tags (
    tagID INT(11) NOT NULL AUTO_INCREMENT,
    tag VARCHAR(255) NOT NULL,
    PRIMARY KEY (tagID)
);

DROP TABLE IF EXISTS followers;
-- followers: Allows a user to follow other users 
CREATE TABLE followers (
    userRelationshipID INT(11) NOT NULL AUTO_INCREMENT,
    followeeID INT(11) NOT NULL,
    followerID INT(11) NOT NULL,
    followedSince DATE NOT NULL,
    UNIQUE (followeeID, followerID),
    FOREIGN KEY (followeeID) REFERENCES users (userID) ON DELETE CASCADE,
    FOREIGN KEY (followerID) REFERENCES users (userID) ON DELETE CASCADE,
    PRIMARY KEY (userRelationshipID)
);

DROP TABLE IF EXISTS likes;
-- Records a user’s interaction on other users’ posts 
CREATE TABLE likes (
    likeID INT(11) AUTO_INCREMENT NOT NULL,
    postID INT(11) NOT NULL,
    likedByUserID INT(11),
    dateLiked DATE NOT NULL, 
    PRIMARY KEY (likeID),
    UNIQUE (postID, likedByUserID),
    FOREIGN KEY (likedByUserID) REFERENCES users (userID) ON DELETE SET NULL,
    FOREIGN KEY (postID) REFERENCES posts (postID) ON DELETE CASCADE
);

/*
Insert data below 
___________________________________________________________________________________
*/

-- insert users into the users table
INSERT INTO users (
    username,
    firstName,
    lastName,
    email,
    phoneNumber,
    signupDate
)
VALUES
    ('ringbearer','Frodo','Baggins','frodo@bagend.com','555-123-4567', '2021-03-11'),
    ('Snips','Ahsoka','Tano','snips@gmail.com','888-867-5309', '2023-07-15'),
    ('4ever_young','Dorian', 'Gray','portrait@gmail.com', '555-123-4560', '2023-09-05'),
    ('enigma', 'Alan', 'Turing','ATuring@BletchleyPark.com','393-291-2848', '2021-01-01'),
    ('AliceOfWonderland', 'Alice', 'Wonderland','alice_curious@rabbit.com','946-529-4827', '2022-04-01')
;

-- insert data into posts table
INSERT INTO posts (
    userID,
    postDate,
    postBody
)
VALUES 
    (4,'2023-07-20','Those who can imagine anything, can create the impossible.' ),
    (4,'2023-08-20', 'Sometimes it is the people who no one imagines anything of who do the things that no one can imagine.'),
    (1,'2023-05-10','I can''t recall the taste of food, nor the sound of water, nor the touch of grass. I''m naked in the dark. There''s nothing--no veil between me and the wheel of fire. I can see him with my waking eyes.'),
    (2,'2024-01-10', 'I have a bad feeling about this'),
    (3,'2023-09-10', 'To define is to limit')
;

-- insert data into followers table
INSERT INTO followers (
    followeeID,
    followerID,
    followedSince            
)
VALUES 
    (2,1,'2023-07-15'),
    (2,3,'2023-07-16'),
    (4,1,'2021-05-01'),
    (1,2,'2023-07-15'),
    (1,3,'2023-05-09')
;

-- insert data into likes table
INSERT INTO likes (
    postID,
    likedByUserID,
    dateLiked
)
VALUES
    (2,1,'2023-08-20'),
    (2,2,'2023-08-20'),
    (2,3,'2023-08-20'),
    (2,5,'2023-08-20'),
    (4,1,'2023-09-10')
;

-- insert data into tags table
INSERT INTO tags  (
    tag
)
VALUES
    ('computerscience'),
    ('rings'),
    ('cats'),
    ('iSeeYou'),
    ('movie')
;

-- insert data into postsHasTags
INSERT INTO postsHasTags (
    postID,
    tagID,
    dateTagged
)
VALUE
    (2,1,'2023-08-20'),
    (2,2,'2023-08-20'),
    (2,3,'2023-08-20'),
    (4,4,'2024-01-10'),
    (5,5,'2023-09-10')
;

select * from users;
select * from posts;
select * from tags;
select * from followers;
select * from postsHasTags;
select * from likes;

describe users;
describe posts;
describe tags;
describe followers;
describe postsHasTags;
describe likes;


SET FOREIGN_KEY_CHECKS=1;
COMMIT;
