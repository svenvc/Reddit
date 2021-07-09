"
I am WARedditLinkEditor.
I am a Seaside WAComponent.
I offer an interface to create a new RedditLink.

Part of the 'Reddit.st - In 10 Cool Pharo Classes' tutorial.
"
Class {
	#name : #RedditLinkEditor,
	#superclass : #WAComponent,
	#instVars : [
		'url',
		'title',
		'captcha'
	],
	#category : #Reddit
}

{ #category : #actions }
RedditLinkEditor >> cancel [
	self answer: false
]

{ #category : #accessing }
RedditLinkEditor >> captcha [
	^ captcha
]

{ #category : #accessing }
RedditLinkEditor >> captcha: anObject [
	captcha := anObject
]

{ #category : #hooks }
RedditLinkEditor >> children [
	^ Array with: self captcha
]

{ #category : #private }
RedditLinkEditor >> createLink [
	^ RedditLink withUrl: self url title: self title
]

{ #category : #initialize }
RedditLinkEditor >> initialize [
	super initialize.
	self
		url: 'http://';
		title: 'title';
		captcha: RedditCaptcha new
]

{ #category : #testing }
RedditLinkEditor >> isTitleMissing [
	^ self title isNil or: [ self title isEmpty or: [ self title = 'title' ] ]
]

{ #category : #testing }
RedditLinkEditor >> isUrlMissing [
	^ self url isNil or: [ self url isEmpty or: [ self url = 'http://' ] ]
]

{ #category : #testing }
RedditLinkEditor >> isUrlValid [
	^ [ 
			ZnClient new
				get: self url;
				isSuccess ]
			on: Error
			do: [ false ]
]

{ #category : #rendering }
RedditLinkEditor >> renderContentOn: html [
	html
		form: [ 
			html paragraph: 'Please enter a URL and title for the link that you want to add:'.
			html textInput
				size: 48;
				title: 'The URL of the new link';
				on: #url of: self.
			html textInput
				size: 48;
				title: 'The title of the new link';
				on: #title of: self.
			html render: self captcha.
			html submitButton on: #cancel of: self.
			html submitButton on: #save of: self ]
]

{ #category : #actions }
RedditLinkEditor >> save [
	self isUrlMissing
		ifTrue: [ ^ self inform: 'Please enter an URL' ].
	self isTitleMissing
		ifTrue: [ ^ self inform: 'Please enter a title' ].
	self captcha isSolved
		ifFalse: [ ^ self inform: 'Please answer the correct sum using digits' ].
	self isUrlValid
		ifFalse: [ ^ self inform: 'The URL you entered did not resolve' ].
	self answer: true
]

{ #category : #accessing }
RedditLinkEditor >> title [
	^ title
]

{ #category : #accessing }
RedditLinkEditor >> title: anObject [
	title := anObject
]

{ #category : #updating }
RedditLinkEditor >> updateRoot: anHtmlRoot [
	super updateRoot: anHtmlRoot.
	anHtmlRoot title: 'Reddit.st - Submit a new link'
]

{ #category : #accessing }
RedditLinkEditor >> url [
	^ url
]

{ #category : #accessing }
RedditLinkEditor >> url: anObject [
	url := anObject
]
