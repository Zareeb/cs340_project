/*

Team 181
Marina Hampton and Zareeb Lorenzana 
DDL.SQL - hand authored
Database of Simple Social App
Date Updated: 02.15.2024

*/

SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT = 0;

-- records the details of users of the app
CREATE TABLE Users (
    userID INT(11) AUTO_INCREMENT NOT NULL,
    username VARCHAR(20) NOT NULL ,
    firstName VARCHAR(255) NOT NULL,
    lastName VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phoneNumber VARCHAR(15) NOT NULL,
    signupDate DATETIME NOT NULL,
    PRIMARY KEY (userID),
    UNIQUE (userID, username, email, phoneNumber)
);

-- records the details of a user’s posts
CREATE TABLE Posts (
    postID INT(11) AUTO_INCREMENT NOT NULL,
    userID INT(11) NOT NULL,
    postDate DATETIME NOT NULL,
    postBody VARCHAR(255) NOT NULL,
    PRIMARY KEY (postID),
    FOREIGN KEY (userID) REFERENCES Users (userID) ON DELETE CASCADE,
    UNIQUE (postID)
);

-- Interaction table PostHasTags between Posts and Tags;
CREATE TABLE PostsHasTags (
    postTagID INT(11) AUTO_INCREMENT NOT NULL,
    postID INT(11) NOT NULL,
    tagID INT(11) NOT NULL,
    dateTagged DATE NOT NULL, 
    PRIMARY KEY (postTagID),
    FOREIGN KEY (postID) REFERENCES Posts (postID) ON DELETE CASCADE,
    FOREIGN KEY (tagID) REFERENCES Tags (tagID) ON DELETE CASCADE,
    UNIQUE (postTagID)
);

-- Tags : Allows users to create tags and organize their posts based on type of content
CREATE TABLE Tags (
    tagID INT(11) NOT NULL AUTO_INCREMENT,
    tag VARCHAR(255) NOT NULL,
    PRIMARY KEY (tagID),
    UNIQUE (tagID)
);

-- Followers: Allows users to follow other users 
CREATE TABLE Followers (
    userFollowerID INT(11) NOT NULL AUTO_INCREMENT,
    followeeID INT(11) NOT NULL,
    followerID INT(11) NOT NULL,
    followedSince DATE NOT NULL,
    FOREIGN KEY (followeeID) REFERENCES Users (userID) ON DELETE CASCADE,
    FOREIGN KEY (followerID) REFERENCES Users (userID) ON DELETE CASCADE,
    PRIMARY KEY (userFollowerID),
    UNIQUE (userFollowerID)
);



-- Interaction table PostsHasLikes ; Records a user’s interaction on other users’ posts; also acts as an intersection table between Users and Posts 
CREATE TABLE PostsHasLikes (
    likeID INT(11) AUTO_INCREMENT NOT NULL,
    postID INT(11) NOT NULL,
    likedByUserID INT(11) NOT NULL,
    dateLiked DATETIME NOT NULL, 
    PRIMARY KEY (likeID),
    FOREIGN KEY (postID) REFERENCES Posts (postID) ON DELETE CASCADE ,
    FOREIGN KEY (likedByUserID) REFERENCES Users (userID) ON DELETE CASCADE,
    UNIQUE (likeID)
);



/*
Insert data below 
___________________________________________________________________________________
*/

-- insert users into the Users table
INSERT INTO Users (
    username,
    firstName,
    lastName,
    email,
    phoneNumber,
    signupDate
)
VALUES
    ('RingBearer','Frodo','Baggins','frodo@bagend.com','5551234567', '2021-03-11 20:00:00'),
    ('Snips','Ahsoka','Tano','snips@gmail.com','8888675309', '2023-07-15 09:00:30'),
    ('ForeverYoung','Dorian', 'Gray','portrait@gmail.com', '5551234560', '2023-09-05 19:00:40'),
    ('CodeBreakerGenius', 'Alan', 'Turing','ATuring@gmail.com','3932912848', '2021-01-01 10:03:04'),
    ('AliceOfWonderland', 'Alice', 'Wonderland','alice_curious@rabbit.com','9465294827', '2022-04-01 10:00:00')
;

-- insert data into Posts table
INSERT INTO Posts (
    userID,
    postDate,
    postBody
)
VALUES 
    (4,'2023-07-20 09:00:00','Graduated from Sherborne!' ),
    (4,'2023-08-20 19:00:00', 'My proof. Called Turing Proof.'),
    (1,'2023-05-10 03:00:00','Gonna wear the one ring!'),
    (2,'2024-01-10 05:40:00', 'I have a bad feeling about this'),
    (3,'2023-09-10 03:00:00', 'To define is to limit')
;

-- insert data into Followers table
INSERT INTO Followers (
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

-- insert data into PostsHasLikes table
INSERT INTO PostsHasLikes (
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

-- insert data into Tags table
INSERT INTO Tags  (
    tag
)
VALUES
    ('computerscience'),
    ('rings'),
    ('cats'),
    ('iSeeYou'),
    ('movie')
;

-- insert data into PostsHasTags
INSERT INTO PostsHasTags (
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

select * from Users;
select * from Posts;
select * from Tags;
select * from Followers;
select * from PostsHasTags;
select * from PostsHasLikes;

describe Users;
describe Posts;
describe Tags;
describe Followers;
describe PostsHasTags;
describe PostsHasLikes;


SET FOREIGN_KEY_CHECKS=1;
COMMIT;