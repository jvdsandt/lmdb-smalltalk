Class {
	#name : #MDBSortedDictionaryPerformaceTests,
	#superclass : #Object,
	#category : #'LightningMDB-Tests-Dictionary'
}

{ #category : #'as yet unclassified' }
MDBSortedDictionaryPerformaceTests >> doDeserializeData: anArray using: aConverter [

	^anArray collect: [ :each | aConverter deserialize: each ]
]

{ #category : #'as yet unclassified' }
MDBSortedDictionaryPerformaceTests >> doSerializeData: anArray using: aConverter [

	^anArray collect: [ :each | LZ4Compressor new compress: (aConverter serialize: each) ]
]

{ #category : #'as yet unclassified' }
MDBSortedDictionaryPerformaceTests >> newTestDictionary: anId [

	^Dictionary new 
		at: 100 put: TimeStamp now ;
		at: 101 put: 'Value-', anId asString ;
		at: 200 put: 27636.78 ;
		at: 201 put: (1 / 3) ;
		at: 'text' put: 'bla bla bla not a very long string.' ;
		yourself.
		
	"self new newTestDictionary: 100"
]

{ #category : #'as yet unclassified' }
MDBSortedDictionaryPerformaceTests >> testSerialization [
	"self new testSerialization"

	| data bytesData converter time |
	
	data := (1 to: 1000) collect: [ :index | self newTestDictionary: index ].
	converter := MDBFuelConverter new.

	time := Time millisecondsToRun: [ bytesData := self doSerializeData: data using: converter ].
	Transcript
		cr ;
		show: 'Serialization time: ', time printString, 'ms.' ;
		cr.
		
	time := Time millisecondsToRun: [
		bytesData := bytesData collect: [ :b | MDBValue allocateFor: (LZ4Compressor new uncompress: b) ].
		data := self doDeserializeData: bytesData using: converter.
		bytesData do: [ :each | each freeData ] ].
	Transcript
		cr ;
		show: 'Deserialization time: ', time printString, 'ms.' ;
		cr
]
