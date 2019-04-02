# SIR-Digger

Modeling the Spread of Ideas on Social Media Using The SIR Disease Model
 Obtain a Twitter account and Twitter API credentials to utilize MATLAB script.  
1.	Obtain a Twitter Account:  https://twitter.com/  - If you already have one, no need to obtain another one. 

2.	Obtain Twitter Developer Account: https://developer.twitter.com/en/apply-for-access.html

3.	Once you have a developer account, email nduncan@mymail.mines.edu to invite you to the “SIR Digger” application within the twitter developer community.  

4.	Obtain API Credentials / Access tokens: 
 

Obtain SIR model in MATLAB:  

1.	Contact Nick Duncan for a copy of the MATLAB scripts:  nduncan@mymail.mines.edu
2.	Once MATLAB scripts are obtained, open up “credentials.m” script.  
- Replace ConsumerKey, ConsumerSecret, AccessToken, and AccessTokenSecret codes with the ones obtained in step 3 above. 

Get overview of MATLAB organization and how to use it.  

Depending on what “idea” you are searching for depends on which script you will utilize.  Ensure you utilize the correct script for the correct search.  Twitter places limits on different searches.  

1.	Search less than 7 days old – Utilize “main7day” script
2.	Searches > 7 days old but  < 30 days old – Utilize “main” script
3.	Search > 30 days old – utilize “mainfullarchive” script  

Modify “main” script for intended query.  

1.	Modify “query” variable on line 19 for 7 day script, line 17 on 30 day script and line 18 of full archive script.   It’s important to have the query formatted correctly.  See the below link to review the rules for the query format:

https://developer.twitter.com/en/docs/tweets/rules-and-filtering/overview/premium-operators  

2.	For 30 day and full archive searches,  modify fromdate and todate variables.  Lines 14 &15 (30 day) 16 &17 (full archive).  Recommend the fromdate and todate be no more than 3 days.  
3.	Run main script.  

View and Analyze results

1.	If SIR results have epidemic behavior, then save the data and results.  For example:

 

2.	If SIR results show an endemic, open up time_adjustment1 script.  For example:
 
Time adjustment1.m script looks to see if the epidemic behavior happens on a shorter timescale.  Adjust the factor variable on line 7 to adjust the time.  Start with a factor value = 10% of the length of the “time” variable.  For example if the length of the “time” variable is 1 x 100, then “factor” = 10.  This gives a good starting point for the optimization routine to adjust the timescale of the SIR model.  

3.	Repeat step 1 above to determine if an epidemic or endemic behavior exist.  If endemic behavior still exist, repeat step 2 by doubling the factor value.  
