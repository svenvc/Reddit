"
I am RedditDatabaseResource.
I hold the specifications of the database connection.

You will have to change #createLogin and do a #resetLogin.

Part of the 'Reddit.st - In 10 Cool Pharo Classes' tutorial.
"
Class {
	#name : #RedditDatabaseResource,
	#superclass : #Object,
	#classVars : [
		'DefaultLogin'
	],
	#category : #Reddit
}

{ #category : #utilities }
RedditDatabaseResource class >> createLogin [
	"When you make changes here, you will most probably want to reset the cached login"
	
	"self resetLogin"
	
	^ Login new
		database: PostgreSQLPlatform new;
		username: 'sven';
		password: '';
		connectString: 'localhost:5432_sven';
		encodingStrategy: #utf8;
		yourself
]

{ #category : #utilities }
RedditDatabaseResource class >> createTables [
	"self createTables"
	"This has to be done only once, be sure to set #login"

	| session |
	session := self session.
	session accessor
		login;
		logging: true.
	session inTransactionDo: [ session createTables ].
	session accessor logout
]

{ #category : #accessing }
RedditDatabaseResource class >> login [
	^ DefaultLogin ifNil: [ DefaultLogin := self createLogin ]
]

{ #category : #accessing }
RedditDatabaseResource class >> login: aLogin [
	"self login: (Login new
		database: PostgreSQLPlatform new;
		username: 'sven';
		password: '';
		connectString: 'localhost:5432_sven';
		encodingStrategy: #utf8;
		yourself)"

	DefaultLogin := aLogin
]

{ #category : #accessing }
RedditDatabaseResource class >> resetLogin [
	self login: nil
]

{ #category : #accessing }
RedditDatabaseResource class >> session [
	^ RedditSchema sessionForLogin: self login
]

{ #category : #utilities }
RedditDatabaseResource class >> testConnection [
	"self testConnection"
	
	| session result |
	session := self session.
	session accessor
		login;
		logging: true.
	result := session accessor executeSQLString: 'SELECT CURRENT_TIME, CURRENT_DATE'.
	session accessor logout.
	^ result
]
