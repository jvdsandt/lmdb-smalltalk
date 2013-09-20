"
A MDBValue is a structure class for the MDB_value C structure. This structure is used for passing keys and data in and out of the database.
"
Class {
	#name : #MDBValue,
	#superclass : #NBExternalStructure,
	#type : #bytes,
	#category : #'LightningMDB-Core'
}

{ #category : #'instance creation' }
MDBValue class >> allocateFor: aStringOrByteArray [

	| buf |
	
	buf := NativeBoost allocate: aStringOrByteArray byteSize.
	NativeBoost memCopy: aStringOrByteArray to: buf size: aStringOrByteArray byteSize.
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

	NativeBoost memCopy: self mvData to: aTargetObject size: self mvSize
]

{ #category : #converting }
MDBValue >> dataAsByteArray [

	| bytes |
	
	bytes := ByteArray new: self mvSize.
	NativeBoost memCopy: self mvData to: bytes size: bytes size.
	^bytes
]

{ #category : #converting }
MDBValue >> dataAsByteString [

	| bytes |
	
	bytes := ByteString new: self mvSize.
	NativeBoost memCopy: self mvData to: bytes size: bytes size.
	^bytes
]

{ #category : #'initialize-release' }
MDBValue >> freeData [

	self mvData free
]
