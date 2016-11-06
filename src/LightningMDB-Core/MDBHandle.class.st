"
A MDBHandle is an abstract base class for all MDB related extrenal objects.
"
Class {
	#name : #MDBHandle,
	#superclass : #FFIExternalObject,
	#pools : [
		'MDBTypes'
	],
	#category : #'LightningMDB-Core'
}

{ #category : #resources }
MDBHandle class >> ffiLibrary [

	^MDBLibrary
]

{ #category : #resources }
MDBHandle class >> ffiLibraryName [

	^self ffiLibrary 
]

{ #category : #internal }
MDBHandle class >> mdbError: anInteger [

	self error: 'MDB Error: ', (self strerror: anInteger)
]

{ #category : #internal }
MDBHandle class >> strerror: err [
	
	^ self ffiCall: #( String mdb_strerror (int err ) ) 
]

{ #category : #internal }
MDBHandle >> check: anInteger [

	anInteger = 0
		ifFalse: [ self mdbError: anInteger ]
]

{ #category : #resources }
MDBHandle >> ffiLibraryName [

	^self class ffiLibraryName 
]

{ #category : #internal }
MDBHandle >> mdbError: anInteger [

	self class mdbError: anInteger
]
