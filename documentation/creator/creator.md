#Help

[View referee documentation](creator/referee)


##Terminology

* See terminology in [Student Documentation](/help/student)


##Contest Creator Capabilities

A contest creator is capable of 

* All Student permissions
* Creating Referees, Tournaments, and Contests

##How To

* Create a Contest
	* Go to the ‘Create a New…’ dropdown in the navbar, and select Contest
	* Fill in all the fields.
		* ‘Referee’- a contest is required to have a referee. That referee will officiate all matches within that contest.
		* ‘Deadline’- date and time when the contest no longer accepts player uploads
* Create a Referee
	* Go to the ‘Create a New…’ dropdown in the navbar, and select Referee
	* Fill in all the fields (except “Upload more files” “Upload Replay Plugin” are not required). 
		* ‘Round limit’- to specify a reasonable limit of rounds the users can specify per challenge/tournament matches.
		* ‘Upload referee’- can be one file, or a number of files within a zip or tar file. A zip or tar file will always need to include a make file. 
		* ‘Upload player include files’- a file (or all files provided in a zipped file) here, these files will be attributed to each player associated with this referee
		* ‘Rules url’- must begin with ‘http://’
			* the system’s will allow a url without it, HOWEVER (this is a bug) any link with this url on the site will be broken. So, if you do not want a broken link, the url must begin with ‘http://’ 
		* ‘Upload Replay Plugin’- if you do not provide this, then viewing a round will allow you to see the round’s results only.
* Create a Tournament
	* Go to the ‘Create a New…’ dropdown in the navbar, and click Tournament. 
	* Fill in all the fields. 
		* ‘Start’- the system will begin the tournament at this time.
		* ‘Tournament type’
			* The two current choices are Round Robin and Single Elimination. The system can run both tournaments. 
			* The Round Robin’s results are displayed in a tabular format, and the end placement of the tournament (who came in first, second, etcetera) is clear. 
			* The Single Elimination’s results are not displayed in a polished format. They are currently displayed in the same format as Round Robin. (is the Round Robin placement correct?)
		* ‘Number of rounds per match’
			* The upper bound of this number is already set by the referee of the contest.
* View or edit a Contest
	* Go to the ‘Edit Existing...’ dropdown in the navbar, and select Contests.
	* Click the ‘edit’ link besides a particular contest
	* See ‘Create a Contest’ above for information about the fields of the form.
* View or edit a Tournament
	* Go to the ‘Edit Existing...’ dropdown in the navbar, and select Contests.
	* Click on the link of the name of the contest that holds the tournament you wish to edit.
		* Click the ‘edit’ link besides a particular tournament
		* See ‘Create a Tournament’ above for information about the fields of the form.
* View or edit a Referee
	* Go to the ‘Edit Existing...’ dropdown in the navbar, and select Referees.
	* Click the ‘edit’ link besides a particular referee
	* See ‘Create a Referee’ above for information about the fields of the form.
