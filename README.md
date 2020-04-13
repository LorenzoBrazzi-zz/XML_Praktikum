# XML Blackjack WebApp

## Installation Requirements
- A downloaded and extracted instance of [Basex-stomp](https://github.com/BaseXdb/basex/tree/stomp)
- [Maven](https://maven.apache.org/download.cgi) or [Eclipse](https://www.eclipse.org/downloads/) to start the webserver (for installation instructions see below)
- [Java JDK 1.8](https://www.oracle.com/java/technologies/javase-jdk8-downloads.html) or greater

## Start the server

### Option 1: Maven (recommendet)

1. Open the pom.xml file that you can find on the first level of the /basex-stomp directory. Int pom.xml, at the repository with the ID 'central', change the URL to the following: "http://insecure.repo1.maven.org/maven2"

2. In your command line navigate to the /basex-stomp directory and type in the following command: 
	`mvn clean install -DskipTests`

3. After that, type in the following command within the same directory:
	`mvn package -DskipTests`

4. Copy the folders listed below (entire folders, not only content)
	1. Copy: `/webapp/xLinkBlackjack` to `/basex-stomp/basex-api/src/main/webapp`
	2. Copy: `/webapp/static/xLinkBlackjack` to `/basex-stomp/basex-api/src/main/webapp/static`
	
5. Start the Jetty server by navigating to the /basex-stomp/basex-api directory and typing in the following commands:
	`mvn jetty:run`

### Option 2: Eclipse
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

## Playing the Game
Supported browsers: Safari, Firefox.

Open the following URL in your Browser

http://localhost:8984/xLinkbj/setup

IMPORTANT: No backslash '/' at the end of the URL
