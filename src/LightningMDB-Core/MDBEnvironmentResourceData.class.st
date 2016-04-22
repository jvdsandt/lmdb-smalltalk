"
A MDBEnvironmentResourceData object is used to close a MDBEnvironment when it is still open and no longer referenced. Optionally other object can be added to a collection of resources. They will receive a #cleanup message just before the environment is closed.
"
Class {
	#name : #MDBEnvironmentResourceData,
	#superclass : #Object,
	#instVars : [
		'handle',
		'otherResources'
	],
	#category : #'LightningMDB-Core'
}

{ #category : #actions }
MDBEnvironmentResourceData >> addResource: aResource [ 
	"Add <aResource> to the receivers collection of other resources. Just before the environment
	is cleaned up this resource will receive the #cleanup message."
	
	^self otherResources add: aResource 
]

{ #category : #actions }
MDBEnvironmentResourceData >> cleanup [
	"Cleanup any resources and close the environment."
	
	otherResources ifNotNil: [ :coll | 
		[ coll isEmpty ]
			whileFalse: [ coll removeLast cleanup ] ].

	handle isNull
		ifFalse: [ 
			MDBEnvironment primClose: handle. 
			handle beNull ]
]

{ #category : #'initialize-release' }
MDBEnvironmentResourceData >> initWithHandle: aHandle [ 

	handle := aHandle 
]

{ #category : #accessing }
MDBEnvironmentResourceData >> otherResources [

	^otherResources ifNil: [ otherResources := OrderedCollection new ]
]
