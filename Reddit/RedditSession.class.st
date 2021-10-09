"
I am RedditSession.
I am a Seaside WASession.
I hold onto a Glorp database session.

Part of the 'Reddit.st - In 10 Cool Pharo Classes' tutorial.
"
Class {
	#name : #RedditSession,
	#superclass : #WASession,
	#instVars : [
		'glorpSession'
	],
	#category : #Reddit
}

{ #category : #accessing }
RedditSession >> glorpSession [
	glorpSession ifNil: [ glorpSession := self newGlorpSession ].
	glorpSession accessor isLoggedIn
		ifFalse: [ glorpSession accessor login ].
	^ glorpSession
]

{ #category : #accessing }
RedditSession >> inUnitOfWorkDo: block [
	^ self withGlorpSession: [ :session |
		session inUnitOfWorkDo: block ]
]

{ #category : #private }
RedditSession >> newGlorpSession [
	| session |
	session := RedditDatabaseResource session.
	session accessor logging: true.
	^ session
]

{ #category : #private }
RedditSession >> teardownGlorpSession [
	glorpSession ifNotNil: [ glorpSession logout ]
]

{ #category : #'parent/child' }
RedditSession >> unregistered [
	super unregistered.
	self teardownGlorpSession
]

{ #category : #accessing }
RedditSession >> withGlorpSession: block [
	| result |
	result := block value: self glorpSession.
	self teardownGlorpSession.
	^ result
]
