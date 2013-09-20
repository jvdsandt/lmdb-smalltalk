Class {
	#name : #MDBEnvironmentTest,
	#superclass : #MDBTest,
	#category : #'LightningMDB-Tests-Core'
}

{ #category : #tests }
MDBEnvironmentTest >> testCreateAndCloseEnvironment [

	| env |
	
	env := MDBEnvironment create.
	self assert: env handle notNil.
	
	env close
]

{ #category : #tests }
MDBEnvironmentTest >> testOpenAndCloseEnvironment [

	| env |
	
	env := MDBEnvironment create.
	self assert: env handle notNil.
	
	env open: self path flags: 0 mode: 8r664.
	
	env close
]
