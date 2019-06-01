Class {
	#name : #BaselineOfLightningMDB,
	#superclass : #Object,
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
				package: 'LightningMDB-Tests-Dictionary' with: [ spec requires: 'LightningMDB-Dictioanry' ].
			
			spec group: 'default' with: #('GitFastImport') ]
]
