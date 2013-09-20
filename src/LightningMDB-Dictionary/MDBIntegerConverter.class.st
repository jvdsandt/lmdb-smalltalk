Class {
	#name : #MDBIntegerConverter,
	#superclass : #MDBObjectConverter,
	#instVars : [
		'minByteSize'
	],
	#category : #'LightningMDB-Dictionary'
}

{ #category : #converting }
MDBIntegerConverter >> deserialize: aMDBValue [

	^aMDBValue dataAsByteArray asInteger
]

{ #category : #accessing }
MDBIntegerConverter >> minByteSize [

	^ minByteSize ifNil: [ minByteSize := 8 ]
]

{ #category : #accessing }
MDBIntegerConverter >> minByteSize: anObject [
	minByteSize := anObject
]

{ #category : #converting }
MDBIntegerConverter >> serialize: anInteger [
	"Convert <anObject> to some ByteArray like object."
	
	| bytes |
	
	bytes := anInteger asByteArray.
	bytes size < self minByteSize 
		ifTrue: [ bytes := (ByteArray new: self minByteSize - bytes size), bytes ].
	^bytes
	
	"100 asByteArray"
	"123456789012345678901234567890 asByteArray"
]
