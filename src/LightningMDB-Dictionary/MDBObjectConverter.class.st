"
I convert key and value objects to binary data and visa versa. 

LightningMDB only stores binary data so we need to convert/serialize an object to a ByteArray like object before it can be saved. When the data is retrieved again it has to be converted/deserialized back to an object.

To serialize an object to binary data I send it the message #asByteArray. No derialization is done so a ByteArray is always the result. In most cases this default behaviour will not fit your needs and you will have to use a subclass of me.
"
Class {
	#name : #MDBObjectConverter,
	#superclass : #Object,
	#category : #'LightningMDB-Dictionary'
}

{ #category : #converting }
MDBObjectConverter >> deserialize: aByteArray [

	^aByteArray
]

{ #category : #internal }
MDBObjectConverter >> getBuffer: minByteSize [

	^ByteArray new: minByteSize
]

{ #category : #converting }
MDBObjectConverter >> serialize: anObject [
	"Convert <anObject> to some ByteArray like object."
	
	^anObject asByteArray
]
