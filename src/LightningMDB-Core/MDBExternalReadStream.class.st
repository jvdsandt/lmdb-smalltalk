Class {
	#name : #MDBExternalReadStream,
	#superclass : #Object,
	#instVars : [
		'address',
		'position',
		'limit'
	],
	#category : #'LightningMDB-Core'
}

{ #category : #'as yet unclassified' }
MDBExternalReadStream >> atEnd [

	^position >= limit - 1
]

{ #category : #'as yet unclassified' }
MDBExternalReadStream >> next [
	
	^ self atEnd 
		ifTrue: [ nil ] 
		ifFalse: [ 
			position := position + 1. 
			address byteAt: position ]
]

{ #category : #'as yet unclassified' }
MDBExternalReadStream >> on: anExternalAddress limit: integer [

	address := anExternalAddress.
	limit := integer.
	position := -1
]
