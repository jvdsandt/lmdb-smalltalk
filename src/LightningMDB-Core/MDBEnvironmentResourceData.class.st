Class {
	#name : #MDBEnvironmentResourceData,
	#superclass : #Object,
	#instVars : [
		'handle',
		'otherResources'
	],
	#category : #'LightningMDB-Core'
}

{ #category : #'as yet unclassified' }
MDBEnvironmentResourceData >> cleanup [

	Transcript cr;show: 'Fin....', handle printString; cr.

	handle isNull
		ifFalse: [ 
			MDBEnvironment primClose: (NBExternalObject new handle: handle value). 
			handle value: 0 ]
]

{ #category : #'as yet unclassified' }
MDBEnvironmentResourceData >> initWithHandle: aHandle [ 

	handle := aHandle 
]
