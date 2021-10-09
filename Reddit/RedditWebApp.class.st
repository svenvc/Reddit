"
I am RedditWebApp.
I am a Seaside WAComponent.
I am the main web GUI for the Reddit application.

Part of the 'Reddit.st - In 10 Cool Pharo Classes' tutorial.
"
Class {
	#name : #RedditWebApp,
	#superclass : #WAComponent,
	#instVars : [
		'linkEditor'
	],
	#category : #Reddit
}

{ #category : #utils }
RedditWebApp class >> durationString: duration [
	^ String streamContents: [ :stream | 
		| needSpace printer |
		needSpace := false.
		printer := [ :value :word | 
			value isZero
				ifFalse: [ 
					needSpace ifTrue: [ stream space ].
					stream nextPutAll: (value pluralize: word).
					needSpace := true ] ].
		printer value: duration days value: 'day'.
		printer value: duration hours value: 'hour'.
		printer value: duration minutes value: 'minute'.
		duration < 60 seconds 
			ifTrue: [ printer value: duration seconds value: 'second' ].
		duration < 1 second 
			ifTrue: [ stream nextPutAll: 'less than a second' ] ]
]

{ #category : #initializing }
RedditWebApp class >> initialize [
	(WAAdmin register: self asApplicationAt: 'reddit')
		preferenceAt: #sessionClass put: RedditSession;
		addLibrary: RedditFileLibrary
]

{ #category : #hooks }
RedditWebApp >> children [
	^ self linkEditor notNil
		ifTrue: [ Array with: self linkEditor ]
		ifFalse: [ super children ]
]

{ #category : #accessing }
RedditWebApp >> highestRankingLinks [
	| query |
	query := (Query read: RedditLink)
		orderBy: [ :each | each points descending ];
		limit: 20;
		yourself.
	^ self session withGlorpSession: [ :session | session execute: query ]
]

{ #category : #accessing }
RedditWebApp >> latestLinks [
	| query |
	query := (Query read: RedditLink)
		orderBy: [ :each | each created descending ];
		limit: 20;
		yourself.
	^ self session withGlorpSession: [ :session | session execute: query ]
]

{ #category : #accessing }
RedditWebApp >> linkEditor [
	^ linkEditor
]

{ #category : #accessing }
RedditWebApp >> linkEditor: anObject [
	linkEditor := anObject
]

{ #category : #rendering }
RedditWebApp >> renderActionsOn: html [
	html
		paragraph: [ 
			html anchor
				callback: [  ];
				with: 'Refresh'.
			self linkEditor
				ifNil: [ 
					html anchor
						callback: [ self showNewLinkEditor ];
						with: 'New Link' ] ]
]

{ #category : #rendering }
RedditWebApp >> renderContentOn: html [
	html heading: 'Reddit.st'.
	html heading
		level3;
		with: 'In 10 cool Pharo classes'.
	self renderActionsOn: html.
	self linkEditor ifNotNil: [ html render: self linkEditor ].
	self renderHighestRankingLinksOn: html.
	self renderLatestLinksOn: html.
	self renderFooterOn: html
]

{ #category : #rendering }
RedditWebApp >> renderFooterOn: html [
	html paragraph 
		class: 'footer';
		with: ('Running for {1} on image {2} and virtual machine {3}' format: {
			(WAUpTimeTracker imageUpTime roundTo: 1 minute) humanReadablePrintString.
			SystemVersion current.
			Smalltalk vm version })
]

{ #category : #rendering }
RedditWebApp >> renderHighestRankingLinksOn: html [
	html heading
		level2;
		with: 'Highest Ranking Links'.
	html orderedList: [ self highestRankingLinks do: [ :each | self renderLink: each on: html ] ]
]

{ #category : #rendering }
RedditWebApp >> renderLatestLinksOn: html [
	html heading
		level2;
		with: 'Latest Links'.
	html orderedList: [ self latestLinks do: [ :each | self renderLink: each on: html ] ]
]

{ #category : #rendering }
RedditWebApp >> renderLink: link on: html [
	html
		listItem: [ 
			html anchor
				url: link url;
				title: link url;
				with: link title.
			html text: ' Posted ' , (self class durationString: link age) , ' ago. '.
			html text: (link points pluralize: ' point'), '. '.
			html anchor
				callback: [ self voteUp: link ];
				title: 'Vote this link up';
				with: 'Up'.
			html space.
			html anchor
				callback: [ self voteDown: link ];
				title: 'Vote this link down';
				with: 'Down' ]
]

{ #category : #actions }
RedditWebApp >> showNewLinkEditor [
	self linkEditor: RedditLinkEditor new.
	self linkEditor
		onAnswer: [ :answer | 
			answer
				ifTrue: [ 
					self session inUnitOfWorkDo: [ :session | 
							session register: self linkEditor createLink ] ].
			self linkEditor: nil ]
]

{ #category : #updating }
RedditWebApp >> updateRoot: anHtmlRoot [
	super updateRoot: anHtmlRoot.
	anHtmlRoot title: 'Reddit.st'.
	anHtmlRoot stylesheet url: (RedditFileLibrary urlOf: #mainCss)
]

{ #category : #actions }
RedditWebApp >> voteDown: link [
	self session inUnitOfWorkDo: [ :session | 
			session register: link.
			link voteDown ]
]

{ #category : #actions }
RedditWebApp >> voteUp: link [
	self session inUnitOfWorkDo: [ :session | 
			session register: link.
			link voteUp ]
]
