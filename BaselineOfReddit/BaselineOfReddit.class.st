"
I am BaselineOfReddit, I load the code of the Reddit.st - in 10 cool Pharo classes - project.

Metacello new
  baseline: 'Reddit';
  repository: 'github://svenvc/Reddit';
  load.
"
Class {
	#name : #BaselineOfReddit,
	#superclass : #BaselineOf,
	#category : #BaselineOfReddit
}

{ #category : #baselines }
BaselineOfReddit >> baselineOf: spec [
	<baseline>
	spec
		for: #common
		do: [
			spec baseline: 'NeoConsole' with: [ spec repository: 'github://svenvc/NeoConsole:master/src' ].
			spec baseline: 'ZincHTTPComponents' with: [ spec repository: 'github://svenvc/zinc:master/repository' ].
			spec baseline: 'Seaside3' with: [ spec repository: 'github://SeasideSt/Seaside:master/repository' ].
			spec baseline: 'P3' with: [ spec repository: 'github://svenvc/P3:master'; loads: #('glorp') ].
			spec package: 'Reddit' with: [ spec requires: #('ZincHTTPComponents' 'Seaside3' 'P3' 'NeoConsole') ].
			spec group: 'default' with: #('Reddit').
			spec group: 'core' with: #('Reddit') ]
]
