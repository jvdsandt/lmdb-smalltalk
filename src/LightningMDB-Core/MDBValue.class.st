"
A MDBValue is a structure class for the MDB_value C structure. This structure is used for passing keys and data in and out of the database.
"
Class {
	#name : #MDBValue,
	#superclass : #FFIExternalStructure,
	#classVars : [
		'OFFSET_MVDATA',
		'OFFSET_MVSIZE'
	],
	#category : #'LightningMDB-Core'
}

{ #category : #'instance creation' }
MDBValue class >> allocateFor: aStringOrByteArray [

	| buf |
	
	buf := ExternalData fromHandle: (ExternalAddress allocate: aStringOrByteArray byteSize)
		type: ExternalType void asPointerType.
	LibC memCopy: aStringOrByteArray to: buf size: aStringOrByteArray byteSize.
	^self new
		mvSize: aStringOrByteArray byteSize ;
		mvData: buf

]

{ #category : #'fields description' }
MDBValue class >> fieldsDesc [
	^#(
		size_t mvSize ;
		void* mvData ; 
	)
]

{ #category : #converting }
MDBValue >> copyDataTo: aTargetObject [

	LibC memCopy: self mvData to: aTargetObject size: self mvSize
]

{ #category : #converting }
MDBValue >> dataAsByteArray [

	| bytes |
	
	bytes := ByteArray new: self mvSize.
	LibC memCopy: self mvData to: bytes size: bytes size.
	^bytes
]

{ #category : #converting }
MDBValue >> dataAsByteString [

	| bytes |
	
	bytes := ByteString new: self mvSize.
	LibC memCopy: self mvData to: bytes size: bytes size.
	^bytes
]

{ #category : #'initialize-release' }
MDBValue >> freeData [

	self mvData free
]

{ #category : #'accessing structure variables' }
MDBValue >> mvData [
	"This method was automatically generated"
	^ExternalData fromHandle: (handle pointerAt: 9) type: ExternalType void asPointerType
]

{ #category : #'accessing structure variables' }
MDBValue >> mvData: anObject [
	"This method was automatically generated"
	handle pointerAt: 9 put: anObject getHandle.
]

{ #category : #'accessing structure variables' }
MDBValue >> mvSize [
	"This method was automatically generated"
	^handle unsignedLongLongAt: 1
]

{ #category : #'accessing structure variables' }
MDBValue >> mvSize: anObject [
	"This method was automatically generated"
	handle unsignedLongLongAt: 1 put: anObject
]
