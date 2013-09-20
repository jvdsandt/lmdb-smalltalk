Class {
	#name : #MDBByteStringConverter,
	#superclass : #MDBObjectConverter,
	#category : #'LightningMDB-Dictionary'
}

{ #category : #converting }
MDBByteStringConverter >> deserialize: aMDBValue [

	^aMDBValue dataAsByteString
]

{ #category : #converting }
MDBByteStringConverter >> serialize: aByteString [
	"Convert <anObject> to some ByteArray like object."
	
	^aByteString
]
