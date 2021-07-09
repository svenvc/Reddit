"
RedditDatabaseTests are unit test for the mapping between the RedditLink class and the REDDIT_LINKS table.

Part of the 'Reddit.st - In 10 Cool Pharo Classes' tutorial.
"
Class {
	#name : #RedditDatabaseTests,
	#superclass : #TestCase,
	#instVars : [
		'session'
	],
	#category : #Reddit
}

{ #category : #running }
RedditDatabaseTests >> runningOnInriaCI [
	| platform ci |
	^ [ 
			platform := OSPlatform current.
			ci := platform environment at: 'CI' ifAbsent: [ '' ].
			ci = 'ci.inria.fr' ]
				on: MessageNotUnderstood
				do: [ false ]
]

{ #category : #running }
RedditDatabaseTests >> setUp [
	self runningOnInriaCI ifTrue: [ ^ self ].
	session := RedditDatabaseResource session.
	session accessor
		logging: true;
		login
]

{ #category : #running }
RedditDatabaseTests >> tearDown [
	self runningOnInriaCI ifTrue: [ ^ self ].
	session accessor logout
]

{ #category : #tests }
RedditDatabaseTests >> testCreate [
	| link url title id |
	self runningOnInriaCI ifTrue: [ self skip ].
	url := 'http://www.seaside.st'.
	title := 'Seaside Unit Test'.
	link := RedditLink withUrl: url title: title.
	session inUnitOfWorkDo: [ session register: link ].
	id := link id.
	self assert: id notNil.
	session reset.
	link := session readOneOf: RedditLink where: [ :each | each id = id ].
	link assertContractUsing: self.
	self assert: link url equals: url.
	self assert: link title equals: title.
	session delete: link
]

{ #category : #tests }
RedditDatabaseTests >> testQuery [
	| links |
	self runningOnInriaCI ifTrue: [ self skip ].
	links := session read: RedditLink.
	links do: [ :each | 
		each assertContractUsing: self.
		self assert: (each isKindOf: RedditLink) ]
]

{ #category : #tests }
RedditDatabaseTests >> testUpdate [
	| link url title id |
	self runningOnInriaCI ifTrue: [ self skip ].
	url := 'http://www.seaside.st'.
	title := 'Seaside Unit Test'.
	link := RedditLink withUrl: url title: title.
	session inUnitOfWorkDo: [ session register: link ].
	id := link id.
	session inUnitOfWorkDo: [ 
		session register: link.
		link voteUp ].
	session reset.
	link := session readOneOf: RedditLink where: [ :each | each id = id ].
	self assert: link points equals: 1.
	session delete: link
]
