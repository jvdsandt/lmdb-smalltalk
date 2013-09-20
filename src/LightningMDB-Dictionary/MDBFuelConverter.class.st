Class {
	#name : #MDBFuelConverter,
	#superclass : #MDBObjectConverter,
	#instVars : [
		'serializer',
		'materializer'
	],
	#category : #'LightningMDB-Dictionary'
}

{ #category : #converting }
MDBFuelConverter >> deserialize: aValueData [

	| buf |
	
	buf := self getBuffer: aValueData mvSize.
	aValueData copyDataTo: buf.
	^(self materializer materializeFrom: buf readStream) root
]

{ #category : #accessing }
MDBFuelConverter >> materializer [

	^ materializer ifNil: [ materializer := FLMaterializer new ]
]

{ #category : #accessing }
MDBFuelConverter >> materializer: aFuelMaterializer [

	materializer := aFuelMaterializer
]

{ #category : #converting }
MDBFuelConverter >> serialize: anObject [ 

	^ByteArray streamContents: [ :stream |
		self serializer serialize: anObject on: stream ]
]

{ #category : #accessing }
MDBFuelConverter >> serializer [

	^ serializer ifNil: [ serializer := FLSerializer new ]
]

{ #category : #accessing }
MDBFuelConverter >> serializer: aFuelSerializer [

	serializer := aFuelSerializer
]
