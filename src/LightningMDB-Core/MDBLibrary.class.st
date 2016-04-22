Class {
	#name : #MDBLibrary,
	#superclass : #FFILibrary,
	#category : #'LightningMDB-Core'
}

{ #category : #'accessing platform' }
MDBLibrary >> macModuleName [

	^'liblmdb.dylib'
]

{ #category : #'accessing platform' }
MDBLibrary >> unixModuleName [

	^'liblmdb.so'
]

{ #category : #'accessing platform' }
MDBLibrary >> win32ModuleName [

	^'liblmdb.dll'
]
