CREATE TABLE COMMENT (
    id                INTEGER       PRIMARY KEY,
    SubmitDate        VARCHAR (255),
    UserGroup         VARCHAR (255),
    Discipline        VARCHAR (255),
    Age               VARCHAR (255),
    Sex               VARCHAR (255),
    textResponse      TEXT,
    sentimentScore    REAL,
    sentimentPolarity VARCHAR (15),
    Year              INTEGER
);

