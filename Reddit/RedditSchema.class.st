"
I am RedditSchema.
I am a Glorp DescriptorSystem.
I describe the ORM mapping of the Reddit application, from the model class RedditLink to the RDBMS table REDDIT_LINKS.

Part of the 'Reddit.st - In 10 Cool Pharo Classes' tutorial.
"
Class {
	#name : #RedditSchema,
	#superclass : #DescriptorSystem,
	#category : #Reddit
}

{ #category : #tables }
RedditSchema >> allTableNames [
	^ #('REDDIT_LINKS')
]

{ #category : #classes }
RedditSchema >> classModelForRedditLink: aClassModel [
	#(#id #url #title #created #points) do: [ :each |
		aClassModel newAttributeNamed: each ]
]

{ #category : #classes }
RedditSchema >> constructAllClasses [
	^ super constructAllClasses
		add: RedditLink;
		yourself
]

{ #category : #mapping }
RedditSchema >> descriptorForRedditLink: aDescriptor [
	| table |
	table := self tableNamed: 'REDDIT_LINKS'.
	aDescriptor table: table.
	#(id url title created points) do: [ :each |
		(aDescriptor newMapping: DirectMapping) 
			from: each to: (table fieldNamed: each) ]

]

{ #category : #tables }
RedditSchema >> tableForREDDIT_LINKS: aTable [
	(aTable createFieldNamed: 'id' type: platform serial) bePrimaryKey.
	aTable createFieldNamed: 'url' type: (platform varchar: 64).
	aTable createFieldNamed: 'title' type: (platform varchar: 64).
	aTable createFieldNamed: 'created' type: platform timestamp.
	aTable createFieldNamed: 'points' type: platform integer
]
