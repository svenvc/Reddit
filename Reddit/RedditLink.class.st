"
I am RedditLink.
I represent a titled URL.
I have an id and a number of points.
I know when I was created.

Part of the 'Reddit.st - In 10 Cool Pharo Classes' tutorial.
"
Class {
	#name : #RedditLink,
	#superclass : #Object,
	#instVars : [
		'id',
		'url',
		'title',
		'created',
		'points'
	],
	#category : #Reddit
}

{ #category : #examples }
RedditLink class >> pharoDotOrg [
     <sampleInstance>
     ^ self withUrl: 'http://pharo.org' title: 'pharo'
]

{ #category : #'instance creation' }
RedditLink class >> withUrl: url title: title [
	^ self new
		url: url;
		title: title;
		yourself
]

{ #category : #accessing }
RedditLink >> age [
	^ DateAndTime now - self created
]

{ #category : #asserting }
RedditLink >> assertContractUsing: object [
	object assert: (self url isNil or: [ self url isString ]).
	object assert: (self title isNil or: [ self title isString ]).
	object assert: (self created isKindOf: DateAndTime).
	object assert: (self points isKindOf: Integer).
	object assert: self age asSeconds >= 0.
	object assert: self printString isString
]

{ #category : #accessing }
RedditLink >> created [
	^ created
]

{ #category : #accessing }
RedditLink >> created: anObject [
	created := anObject
]

{ #category : #accessing }
RedditLink >> id [
	^ id
]

{ #category : #accessing }
RedditLink >> id: anObject [
	id := anObject
]

{ #category : #initialize }
RedditLink >> initialize [
	self
		points: 0;
		created: DateAndTime now
]

{ #category : #accessing }
RedditLink >> points [
	^ points
]

{ #category : #accessing }
RedditLink >> points: anObject [
	points := anObject
]

{ #category : #printing }
RedditLink >> printOn: stream [
	super printOn: stream.
	stream nextPut: $(.
	self url printOn: stream.
	stream nextPut: $,.
	self title printOn: stream.
	stream nextPut: $)
]

{ #category : #accessing }
RedditLink >> title [
	^ title
]

{ #category : #accessing }
RedditLink >> title: anObject [
	title := anObject
]

{ #category : #accessing }
RedditLink >> url [
	^ url
]

{ #category : #accessing }
RedditLink >> url: anObject [
	url := anObject
]

{ #category : #asserting }
RedditLink >> validate [
	self assertContractUsing: self
]

{ #category : #actions }
RedditLink >> voteDown [
	self points > 0
		ifTrue: [ self points: self points - 1 ]
]

{ #category : #actions }
RedditLink >> voteUp [
	self points: self points + 1
]
