Class {
	#name : #MDBSortedDictionaryTest,
	#superclass : #TestCase,
	#instVars : [
		'dictionary'
	],
	#category : #'LightningMDB-Tests-Dictionary'
}

{ #category : #'as yet unclassified' }
MDBSortedDictionaryTest >> path [

	^self class name asString
]

{ #category : #running }
MDBSortedDictionaryTest >> tearDown [

	dictionary notNil
		ifTrue: [ 
			dictionary release.
			dictionary := nil ]
]

{ #category : #tests }
MDBSortedDictionaryTest >> testAtPut [

	| value |
	
	dictionary := MDBSortedDictionary open: 'db1' in: self path.
	
	dictionary at: 'key-A' put: 'value-A'.
	self assert: (dictionary at: 'key-A') = 'value-A'.
	
	value := Array with: Date today with: (Set with: 543 with: 123 / 456).
	dictionary at: 'key-B' put: value.
	self assert: (dictionary at: 'key-B') = value.
	
	dictionary environment stat inspect
	
]

{ #category : #tests }
MDBSortedDictionaryTest >> testAtPutMany [

	| value |
	
	dictionary := MDBSortedDictionary open: 'db1' in: self path.
	dictionary empty.
	
	1 to: 500 do: [ :index |
		value := Dictionary new 
			at: 100 put: TimeStamp now ;
			at: 101 put: 'Value-', index asString ;
			at: 200 put: 27636.78 / index ;
			at: 201 put: (1 / 3) ;
			yourself.
		dictionary at: 'key-', (index printStringPadded: 4) put: value ].
	
	self assert: dictionary size = 500.
	self assert: dictionary keys last = 'key-0500'
]

{ #category : #tests }
MDBSortedDictionaryTest >> testEmptyAndSize [

	dictionary := MDBSortedDictionary open: 'db1' in: self path.
	
	dictionary empty.
	self assert: dictionary isEmpty.
	self assert: dictionary size = 0.
	
	dictionary at: 'key-A' put: 'value-A'.
	self deny: dictionary isEmpty.
	self assert: dictionary size = 1.
	
	dictionary empty.
	self assert: dictionary isEmpty.
	self assert: dictionary size = 0.
	

]

{ #category : #tests }
MDBSortedDictionaryTest >> testKeysAndValues [

	dictionary := MDBSortedDictionary open: 'db1' in: self path.
	
	dictionary empty.
	dictionary at: 'key-A' put: 'value-A'.
	dictionary at: 'key-B' put: 'value-B'.

	self assert: dictionary keys asArray = #( 'key-A' 'key-B' ).
	self assert: dictionary values asArray = #( 'value-A' 'value-B' ).
]
