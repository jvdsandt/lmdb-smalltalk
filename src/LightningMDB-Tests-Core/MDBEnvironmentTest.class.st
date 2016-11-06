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
	
	env close.
	self assert: env getHandle isNull
]

{ #category : #tests }
MDBEnvironmentTest >> testGetMaxkeysize [

	| env keysize |
	
	env := MDBEnvironment create.
	keysize := env maxkeysize.
	self assert: keysize > 0.
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

{ #category : #tests }
MDBEnvironmentTest >> testStat [

	| env stats |
	
	env := MDBEnvironment create.
	env open: self path flags: 0 mode: 8r664.
	stats := env stat.
	self assert: stats entries equals: 0.
	env close
]

{ #category : #tests }
MDBEnvironmentTest >> testVersion [

	self assert: MDBEnvironment version isString
]
