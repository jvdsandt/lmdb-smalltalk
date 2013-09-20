Class {
	#name : #MDBTest,
	#superclass : #TestCase,
	#category : #'LightningMDB-Tests-Core'
}

{ #category : #accessing }
MDBTest >> path [

	| ref |

	ref := (FileSystem disk referenceTo: self class name asString) asAbsolute.
	ref isDirectory
		ifFalse: [ ref createDirectory ].
		
	^ref pathString
]
