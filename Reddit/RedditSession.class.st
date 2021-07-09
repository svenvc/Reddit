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

{ #category : #private }
RedditSession >> newGlorpSession [
	| session |
	session := RedditDatabaseResource session.
	session accessor logging: true.
	^ session
]

{ #category : #private }
RedditSession >> teardownGlorpSession [
	self glorpSession logout
]

{ #category : #'parent/child' }
RedditSession >> unregistered [
	super unregistered.
	self teardownGlorpSession
]
