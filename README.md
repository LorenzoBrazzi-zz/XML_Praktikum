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
	2. In Eclipse "File" - "Open Projects from File System"
	3. Choose directory and navigate to the directory of the extracted STOMP BaseX server
	4. Make sure “Search for nested projects” is ticked as BaseX consists of four sub projects. It should find five projects (including the Maven project)
	5. Click finish to import the projects
	6. Make sure that your BaseX Home path is set to the newly downloaded BaseX servers webapp and db folder. For more information on BaseX's home directory visit http:// docs.basex.org/wiki/Configuration.
	7. BaseX consists of four main projects: basex-api, basex-core, basex-examples and basex-tests
	8. In the basex-api project the BaseXHTTP.java can be started with a valid run configuration, so make sure that in “Run configurations” BaseXHTTP is selected as main class and basex-api as project
	9. Run the STOMP BaseX Server, the server starts and prints status information like the HTTP ports
	10. Test if the server is running by navigating to localhost:8984 in your browser


	
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
