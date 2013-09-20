"
A MDBEncodedStringConverter is xxxxxxxxx.

Instance Variables
	encoder:		<ZnCharacterEncoder>

"
Class {
	#name : #MDBEncodedStringConverter,
	#superclass : #MDBObjectConverter,
	#instVars : [
		'encoder'
	],
	#category : #'LightningMDB-Dictionary'
}

{ #category : #converting }
MDBEncodedStringConverter >> deserialize: aMDBValue [

	^self encoder decodeBytes: aMDBValue dataAsByteArray
]

{ #category : #accessing }
MDBEncodedStringConverter >> encoder [
	^ encoder ifNil: [ encoder := ZnUTF8Encoder new ]
]

{ #category : #accessing }
MDBEncodedStringConverter >> encoder: anObject [
	encoder := anObject
]

{ #category : #converting }
MDBEncodedStringConverter >> serialize: aString [
	"Convert <anObject> to some ByteArray like object."
	
	^self encoder encodeString: aString
]
