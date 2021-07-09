"
RedditLinkTests are unit tests for RedditLink.

Part of the 'Reddit.st - In 10 Cool Pharo Classes' tutorial.
"
Class {
	#name : #RedditLinkTests,
	#superclass : #TestCase,
	#category : #Reddit
}

{ #category : #testing }
RedditLinkTests >> testCreate [
	| link url title |
	url := 'http://www.seaside.st'.
	title := 'Seaside'.
	link := RedditLink withUrl: url title: title.
	link assertContractUsing: self.
	self assert: link points isZero.
	self assert: link url equals: url.
	self assert: link title equals: title
]

{ #category : #testing }
RedditLinkTests >> testInitialState [
	| link |
	link := RedditLink new.
	link assertContractUsing: self.
	self assert: link points isZero
]

{ #category : #testing }
RedditLinkTests >> testVoting [
	| link |
	link := RedditLink new.
	link assertContractUsing: self.
	self assert: link points isZero.
	link voteUp.
	self assert: link points equals: 1.
	link voteDown.
	self assert: link points isZero.
	link voteDown.
	self assert: link points isZero
]
