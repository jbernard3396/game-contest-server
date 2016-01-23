#Game Contest Server - Student Documentation

The Game Contest Website is an interactive, web based manager for automated turn-based game contests.

##Terminology

* Player- a student’s submitted file to play in a contest.
* Rounds- one specific instance of a game. For example, a single game of checkers, or a single game of risk. Consists of two or more players.
* Matches- 1 or more rounds, each round with the same players.
* Tournaments- a competition between two or more players. The competition consists of a series of matches. For example, a single elimination tournament.
* Contests- 1 or more tournaments. It may not be the case that every tournament has the same players. For example, a contest consisting of two tournaments. The first tournament consists of each player playing a single match. If a given player cannot successfully complete a match (e.g. the player enters an infinite loop and thus fails to complete a turn), then that player does not enter the second tournament.
* Referee- the instructor’s program that defines the rules of matches, and enforces those rules.

##Student Capabilities

Student is capable of 

* Uploading Players 
* Challenging other students
* Viewing all contests, as well as tournaments and tournament matches within those contests
* Viewing all challenge matches in which they own one of the players. But they may not view any challenge matches in which they do not own one of the players.

##How To

* Create a Player
	* Click ‘Upload Code’ in the navbar (the horizontal bar at the top). Or,
		* Go to Contests tabs
		* Select a Contest under the list
		* Select ‘New Player’ link under the Actions section
	* Fill in all the fields and click ‘Create Player’ 
* Challenge another player
	* Click ‘Challenge Classmate’ in the navbar (the horizontal bar at the top). Or,
		* Go to Contests tab
		* Select a Contest under the list
		* Select ‘Challenge other players’ link under the Actions section 
	* Fill in all the fields and click ‘Challenge!’ 
