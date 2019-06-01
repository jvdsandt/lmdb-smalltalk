Class {
	#name : #BaselineOfLightningMDB,
	#superclass : #BaselineOf,
	#category : #BaselineOfLightningMDB
}

{ #category : #baselines }
BaselineOfLightningMDB >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ 
			spec 
				package: 'LightningMDB-Core';
				package: 'LightningMDB-Tests-Core' with: [ spec requires: 'LightningMDB-Core' ];
				package: 'LightningMDB-Dictionary' with: [ spec requires: 'LightningMDB-Core' ];
				package: 'LightningMDB-Tests-Dictionary' with: [ spec requires: 'LightningMDB-Dictionary' ].
			
			spec 
				group: 'default' 
				with: #( 'LightningMDB-Core' 'LightningMDB-Tests-Core' 'LightningMDB-Dictionary' 'LightningMDB-Tests-Dictionary' ) ]
]
