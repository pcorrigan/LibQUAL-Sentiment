CREATE TABLE KW_INSTANCE (
    sentimentScore    DECIMAL DEFAULT (0),
    sentimentPolarity CHAR,
    relevance         DECIMAL NOT NULL,
    commentId         INTEGER REFERENCES COMMENT (id) MATCH SIMPLE,
    keywordText       CHAR    COLLATE NOCASE
);

