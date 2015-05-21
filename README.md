# LibQUAL-Sentiment ANALYSIS WITH AlchemyAPI
Perform sentiment analysis on LibQUAL+ comments using AlchemyAPI

Open-ended respondent comments are a valuable complement to the regular quantitative findings provided by most surveys. 
While reading every comment provides insight for the investigator, more systematic analysis and summarization of extensive 
qualitative feedback is a time-consuming task.
Recent advances in  sentiment analysis, harnessing natural language processing, text analysis, computational linguistics 
and machine deep learning have opened a rich seam of possibilities for the automation of a range of hitherto, human-only tasks. 

The AlchemyAPI conveniently exposes the necessary computing power, algorithms and data via well-defined interfaces to allow 
us explore these possibilities.

This project is a recipe to:

- Parse the textfile output of a set of LibQUAL+ comments (multiple files over multiple years are accommodated)
- Submit each comment to the AlchemyAPI for both document and keyword level sentiment analysis
- Store the LibQUAL+ data together with *per comment*, and *per keyword* sentiment scores in a SQlite database. 
- /additionally store Sentiment polarity and keyword relevance.
- Provide a series of SQL statements and custome queries
- Visualize the data

Disclaimer

Use this software at your risk. 
