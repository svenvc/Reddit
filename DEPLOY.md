# Deploy instructions

Here are instructions on how to deploy the Reddit.st example web application on a small Ubuntu Linux server.

This is a basic installation for now, it lacks proper process control (monitoring, auto restart) or up to date HTTPS (using a reverse proxy), nor any form of load balancing, but these can be added easily later on. This is a naked, plain HTTP server.

One option is to use an Amazon AWS EC2 T4g.micro instance (1 GB) with Ubuntu Server 20.04.x LTS.

These machines use an ARM64 CPU (AWS Graviton2, Neoverse N1, Cortex-A76, ARM v8).

- https://aws.amazon.com/ec2/graviton/
- https://aws.amazon.com/ec2/instance-types/t4/
- https://en.wikipedia.org/wiki/Annapurna_Labs#AWS_Graviton2

Another option is to use a Microsoft Azure Standard B1ls (1 vcpus, 0.5 GiB memory, Intel x86_64) with Ubuntu Server 20.04.x LTS.

DigitalOcean would be another cheap option.

You might need to install some extra Ubuntu packages here or there (sudo apt install XX). Note that we are running 64-bit Pharo on a 64-bit OS.

First we need to install Pharo 9, using its Pharo Zeroconf Script tools (https://get.pharo.org). This gives us a local user-space installation.

````bash
$ mkdir reddit
$ cd reddit/
$ curl http://get.pharo.org/90+vm | bash
$ ./pharo -version
$ ./pharo Pharo.image printVersion
$ ./pharo Pharo.image save reddit
````

Now we can load the project's code into the reddit.st image.

````bash
$ ./pharo reddit.image metacello install github://svenvc/Reddit:main/ BaselineOfReddit
````

The Reddit.st application uses persistency to a PostgreSQL database (using P3 and Glorp), so we need to install postgresql and configure it a bit.

````bash
$ sudo apt install postgresql
$ sudo su postgres
$ psql
postgres=# create user reddit with password 'secret';
postgres=# create database reddit_db with owner reddit encoding UTF8;
$ exit
$ psql -U reddit -h localhost reddit_db
````

We can now validate that our application can access the database. 
We do this using NeoConsole's REPL tool.
At the end we'll run an expression to create the necessary database tables.

````Smalltalk
$ ./pharo reddit.image NeoConsole repl
NeoConsole Pharo-9.0.0+build.1520.sha.25e11fc03bf7136d3f50f428726a8227f0a98415 (64 Bit)

pharo> (P3Client new url: 'psql://reddit:secret@localhost/reddit_db') in: [ :client | [ client isWorking ] ensure: [ client close ] ].

true

pharo> P3LogEvent logToTranscript

an AnnouncementSubscription

pharo> (P3Client new url: 'psql://reddit:secret@localhost/reddit_db') in: [ :client | [ client isWorking ] ensure: [ client close ] ].

2021-07-09 19:38:21 005 [P3] 437436 #Connect psql://reddit@localhost:5432/reddit_db MD5Password
2021-07-09 19:38:21 006 [P3] 437436 #Query SELECT 65 AS N
2021-07-09 19:38:21 007 [P3] 437436 #Result SELECT 1, 1 record, 1 colum, 0 ms
2021-07-09 19:38:21 008 [P3] 437436 #Close

true

pharo> RedditDatabaseResource login: (Login new
		database: PostgreSQLPlatform new;
		username: 'reddit';
		password: 'secret';
		connectString: 'localhost:5432_reddit_db';
		encodingStrategy: #utf8;
		yourself).

RedditDatabaseResource

pharo> RedditDatabaseResource login

a Login(a PostgreSQLPlatform, 'reddit', 'localhost:5432_reddit_db', '')

pharo> PharoDatabaseAccessor DefaultDriver: P3DatabaseDriver.

PharoDatabaseAccessor

pharo> RedditDatabaseResource testConnection

2021-07-09 19:42:18 009 [P3] 437456 #Connect psql://reddit@localhost:5432/reddit_db MD5Password
SELECT CURRENT_TIME, CURRENT_DATE
2021-07-09 19:42:18 010 [P3] 437456 #Query SELECT CURRENT_TIME, CURRENT_DATE
2021-07-09 19:42:18 011 [P3] 437456 #Result SELECT 1, 1 record, 2 colums, 0 ms
(0.0 s)
Logout
2021-07-09 19:42:18 012 [P3] 437456 #Close
Logout finished

an Array(an Array(7:42:18.021463 pm 9 July 2021))

pharo> RedditDatabaseResource createTables

Begin Transaction
Create sequence REDDIT_LINKS_id_seq
(0.022 s)
CREATE TABLE REDDIT_LINKS (id integer  NOT NULL ,url character varying(64)  NULL ,title character varying(64)  NULL ,created timestamp without time zone  NULL ,points integer  NULL , CONSTRAINT REDDIT_LINKS_PK PRIMARY KEY  (id), CONSTRAINT REDDIT_LINKS_UNIQ UNIQUE  (id))
(0.014 s)
Commit Transaction
Logout
Logout finished

RedditDatabaseResource

pharo> quit
Bye!
````

Great! Now we are ready to run the application server.

````bash
$ cat run.sh
#!/bin/bash
echo Starting the Reddit Seaside Web Application
nohup ./pharo reddit.image run.st &
````

The run script itself contains the necessary Pharo code to launch our application.

````Smalltalk
$ cat run.st
(NeoConsoleTranscript onFileNamed: 'server-{1}.log') install.

Transcript crShow: 'Starting '; show: (NeoConsoleTelnetServer startOn: 42011).

PharoDatabaseAccessor DefaultDriver: P3DatabaseDriver.

RedditDatabaseResource login: 
	(Login new
		database: PostgreSQLPlatform new;
		username: 'reddit';
		password: 'secret';
		connectString: 'localhost:5432_reddit_db';
		encodingStrategy: #utf8;
		yourself).

ZnZincServerAdaptor startOn: 1701.

ZnZincServerAdaptor default server logLevel: 2; logToTranscript.

WAAdmin clearAll.
WAEnvironment configureApplicationDefaults.
WAEnvironment registerDefaultRequestHandlers.
WAAdmin applicationDefaults removeParent: WADevelopmentConfiguration instance.
WAAdmin applicationExceptionHandlingDefaults at: #exceptionHandler put: WAErrorHandler.
RedditWebApp initialize.
WAAdmin defaultDispatcher defaultName: 'reddit'.

Transcript crShow: 'Reddit Seaside Web Application is ready.'.
````

By invoking the run.sh script our application server starts in the background. 
If necessary we can connect to it using NeoConsole's REPL over telnet.

````bash
$ cat repl.sh 
#!/bin/bash
echo Connecting to Telnet REPL at locahost:42011
rlwrap telnet localhost 42011
````

