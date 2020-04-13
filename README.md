# XML Blackjack WebApp

## Installation Requirements
- A downloaded and extracted instance of [Basex-stomp](https://github.com/BaseXdb/basex/tree/stomp)
- [Maven](https://maven.apache.org/download.cgi) or [Eclipse](https://www.eclipse.org/downloads/) to start the webserver (for installation instructions see below)
- [Java JDK 1.8](https://www.oracle.com/java/technologies/javase-jdk8-downloads.html) or greater

## Start the server

1. Install the BaseX server here : http://basex.org/download/

2. Copy the "webapp" folder of this project into the BaseX webapp folder

### Option 1: Maven (recommendet)
	1. Download and install Eclipse IDE for Java Developers
	
Open the BaseX GUI and create a new database by following the steps
	1. Database
	2. New...
	3. Input file or directory: [BaseX folder]/webapp/blackjack/db_init/casino.xml
	4. Name of database: blackjack
	5. "Ok"

### Option 2: Eclipse
Run the 'basexhttp' script in the 'basex/bin'

## Playing the Game
Supported browsers: 
	- Safari
	- Firefox

Open the following URL in your Browser

http://127.0.0.1:8984/bj

IMPORTANT: No backslash '/' at the end of the URL
