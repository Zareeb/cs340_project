/*
Team 181 - Marina Hampton, Zareeb Lorenzana, & Skyler Santos
DDL.SQL - hand authored
Database of Simple Social App
Date Updated: 03.07.2024
*/

SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT = 0;

DROP TABLE IF EXISTS users;
-- records the details of users of the app
CREATE TABLE users (
    userID INT(11) AUTO_INCREMENT NOT NULL,
    username VARCHAR(20) NOT NULL ,
    firstName VARCHAR(255) NOT NULL,
    lastName VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phoneNumber VARCHAR(15) NOT NULL,
    signupDate DATE NOT NULL,
    PRIMARY KEY (userID),
    UNIQUE (userID, username, email, phoneNumber)
);

DROP TABLE IF EXISTS posts;
-- records the details of a user’s posts
CREATE TABLE posts (
    postID INT(11) AUTO_INCREMENT NOT NULL,
    userID INT(11) NOT NULL,
    postDate DATE NOT NULL,
    postBody VARCHAR(255) NOT NULL,
    PRIMARY KEY (postID),
    FOREIGN KEY (userID) REFERENCES users (userID) ON DELETE CASCADE,
    UNIQUE (postID)
);

DROP TABLE IF EXISTS postsHasTags;
-- Interaction table postsHasTags between Posts and tags;
CREATE TABLE postsHasTags (
    postTagID INT(11) AUTO_INCREMENT NOT NULL,
    postID INT(11) NOT NULL,
    tagID INT(11) NOT NULL,
    dateTagged DATE NOT NULL, 
    PRIMARY KEY (postTagID),
    FOREIGN KEY (postID) REFERENCES Posts (postID) ON DELETE CASCADE,
    FOREIGN KEY (tagID) REFERENCES tags (tagID) ON DELETE CASCADE,
    UNIQUE (postTagID)
);

DROP TABLE IF EXISTS tags;
-- tags : Allows users to create tags and organize their posts based on type of content
CREATE TABLE tags (
    tagID INT(11) NOT NULL AUTO_INCREMENT,
    tag VARCHAR(255) NOT NULL,
    PRIMARY KEY (tagID),
    UNIQUE (tagID)
);

DROP TABLE IF EXISTS followers;
-- followers: Allows a user to follow other users 
CREATE TABLE followers (
    userRelationshipID INT(11) NOT NULL AUTO_INCREMENT,
    followeeID INT(11) NOT NULL,
    followerID INT(11) NOT NULL,
    followedSince DATE NOT NULL,
    FOREIGN KEY (followeeID) REFERENCES users (userID) ON DELETE CASCADE,
    FOREIGN KEY (followerID) REFERENCES users (userID) ON DELETE CASCADE,
    PRIMARY KEY (userRelationshipID),
    UNIQUE (userRelationshipID)
);

DROP TABLE IF EXISTS likes;
-- Records a user’s interaction on other users’ posts; also acts as an intersection table between users and Posts 
CREATE TABLE likes (
    likeID INT(11) AUTO_INCREMENT NOT NULL,
    postID INT(11) NOT NULL,
    likedByUserID INT(11),
    dateLiked DATE NOT NULL, 
    PRIMARY KEY (likeID),
    FOREIGN KEY (postID) REFERENCES posts (postID) ON DELETE CASCADE ,
    FOREIGN KEY (likedByUserID) REFERENCES users (userID) ON DELETE SET NULL,
    UNIQUE (likeID)
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
    ('bagendbaggins','Frodo','Baggins','frodo@bagend.com','5551234567', '2021-03-11 20:00:00'),
    ('Snips','Ahsoka','Tano','snips@gmail.com','8888675309', '2023-07-15 09:00:30'),
    ('4ever_young','Dorian', 'Gray','portrait@gmail.com', '5551234560', '2023-09-05 19:00:40'),
    ('enigma', 'Alan', 'Turing','ATuring@gmail.com','3932912848', '2021-01-01 10:03:04'),
    ('AliceOfWonderland', 'Alice', 'Wonderland','alice_curious@rabbit.com','9465294827', '2022-04-01 10:00:00')
;

-- insert data into posts table
INSERT INTO posts (
    userID,
    postDate,
    postBody
)
VALUES 
    (4,'2023-07-20 09:00:00','Those who can imagine anything, can create the impossible.' ),
    (4,'2023-08-20 19:00:00', 'Sometimes it is the people who no one imagines anything of who do the things that no one can imagine.'),
    (1,'2023-05-10 03:00:00','Feeling risky, might wear the One Ring!'),
    (2,'2024-01-10 05:40:00', 'I have a bad feeling about this'),
    (3,'2023-09-10 03:00:00', 'To define is to limit')
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
    (2,1,'2023-08-20 19:01:00'),
    (2,2,'2023-08-20 19:10:00'),
    (2,3,'2023-08-20 19:20:00'),
    (2,5,'2023-08-20 19:45:00'),
    (4,1,'2023-09-10 03:00:00')
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
