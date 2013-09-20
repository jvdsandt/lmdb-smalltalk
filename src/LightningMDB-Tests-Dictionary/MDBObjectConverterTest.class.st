Class {
	#name : #MDBObjectConverterTest,
	#superclass : #TestCase,
	#instVars : [
		'converter'
	],
	#category : #'LightningMDB-Tests-Dictionary'
}

{ #category : #accessing }
MDBObjectConverterTest >> converter [

	^converter ifNil: [ converter := MDBObjectConverter new ]
]

{ #category : #tests }
MDBObjectConverterTest >> testConversion [

	self assert: (self converter serialize: #( 10 20 30 ) asByteArray) = #( 10 20 30 ) asByteArray.
	

]
