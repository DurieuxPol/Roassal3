Class {
	#name : #RSBoxPlotShapeTest,
	#superclass : #TestCase,
	#category : #'Roassal3-Chart-Tests-Core'
}

{ #category : #tests }
RSBoxPlotShapeTest >> testBoxGraphHasScales [
	| boxGraph data aPoint aScale |
	data := { 1. 2. 3. 4. 5. }.
	aPoint := 1@1.
	aScale := NSLinearScale new.
	boxGraph := RSBoxPlotShape data: data.
	boxGraph scales: {aScale. aScale }.
	self assert: boxGraph xScale class equals: NSLinearScale.
	self assert: boxGraph yScale class equals: NSLinearScale.
	self assert: (boxGraph scalePoint: aPoint) class equals: Point.
]

{ #category : #tests }
RSBoxPlotShapeTest >> testBoxGraphHasStatisticalMeasures [
	| boxGraph data |
	data := { 1. 2. 3. 4. 5. }.
	boxGraph := RSBoxPlotShape data: data.
	self assert: boxGraph statisticalMeasures class equals: RSStatisticalMeasures.
	self assert: boxGraph median closeTo: 3 precision: 4.
]

{ #category : #tests }
RSBoxPlotShapeTest >> testCenter [
	| boxGraph data  center aScale |
	data := { 1. 2. 3. 4. 5. }.
	aScale := NSLinearScale new.
	boxGraph := RSBoxPlotShape data: data scales: {aScale. aScale }.
	center := boxGraph center.
	self assert: center equals: 1.
]

{ #category : #tests }
RSBoxPlotShapeTest >> testColor [
	| boxGraph data   |
	data := { 12. 12. 13. 14. 15. 24. }.
	boxGraph := RSBoxPlotShape data: data.
	boxGraph color: Color red.
	self assert: boxGraph color equals: Color red.
]

{ #category : #tests }
RSBoxPlotShapeTest >> testData [
	| boxGraph data   |
	data := { 12. 12. 13. 14. 15. 24. }.
	boxGraph := RSBoxPlotShape data: data.
	self assert: boxGraph data equals: data.
]

{ #category : #tests }
RSBoxPlotShapeTest >> testDefaultGraphCenter [
	| boxGraph data|
	data := { 1. 2. 3. 4. 5. }.
	boxGraph := RSBoxPlotShape data: data.
	self assert: boxGraph graphCenter equals: 1.
]

{ #category : #tests }
RSBoxPlotShapeTest >> testDefaultLowerWhisker [
	| data boxShape |
	data := { 5. 1. 2. 3. 4. }.
	boxShape := RSBoxPlotShape data: data.
	self assert: boxShape lowerWhisker class equals: RSPolyline.
	self assert: boxShape lowerWhisker color equals: Color black.
	self assert: boxShape lowerWhisker border width equals: 1.
]

{ #category : #tests }
RSBoxPlotShapeTest >> testDefaultUpperWhisker [
	| data boxShape |
	data := { 5. 1. 2. 3. 4. }.
	boxShape := RSBoxPlotShape data: data.
	self assert: boxShape upperWhisker class equals: RSPolyline.
	self assert: boxShape upperWhisker color equals: Color black.
	self assert: boxShape upperWhisker border width equals: 1.
]

{ #category : #tests }
RSBoxPlotShapeTest >> testLowerLimit [
	| boxGraph data   |
	data := { 12. 12. 13. 14. 15. 24. }.
	boxGraph := RSBoxPlotShape data: data.
	self assert: boxGraph lowerLimit closeTo: 12 precision: 1.
]

{ #category : #tests }
RSBoxPlotShapeTest >> testMaxYValueIsOutlier [
	| boxGraph data   |
	data := { 12. 12. 13. 14. 15. 24. }.
	boxGraph := RSBoxPlotShape data: data.
	self assert: boxGraph maxYValue equals: 24.
]

{ #category : #tests }
RSBoxPlotShapeTest >> testMaxYValueIsUpperLimit [
	| boxGraph data   |
	data := { 12. 12. 13. 14. 15. }.
	boxGraph := RSBoxPlotShape data: data.
	self assert: boxGraph maxYValue equals: 15.
]

{ #category : #tests }
RSBoxPlotShapeTest >> testMinYValueIsLowerLimit [
	| boxGraph data   |
	data := { 12. 12. 13. 14. 15. }.
	boxGraph := RSBoxPlotShape data: data.
	self assert: boxGraph minYValue equals: 12.
]

{ #category : #tests }
RSBoxPlotShapeTest >> testOutlierValues [
	| boxGraph data   |
	data := { 12. 12. 13. 14. 15. 24. }.
	boxGraph := RSBoxPlotShape data: data.
	self assert: boxGraph outlierValues size equals: 1.
	self assert: boxGraph outlierValues first equals: 24.
]

{ #category : #tests }
RSBoxPlotShapeTest >> testUpperLimit [
	| boxGraph data   |
	data := { 12. 12. 13. 14. 15. 24. }.
	boxGraph := RSBoxPlotShape data: data.
	self assert: boxGraph upperLimit closeTo: 15 precision: 1.
]

{ #category : #tests }
RSBoxPlotShapeTest >> testWhiskerLinesFormat [
	| data boxShape xScale yScale |
	data := { 5. 1. 2. 3. 4. }.
	xScale := NSScale ordinal
		domain: {1};
		rangeBands: {0. 360. }.
	yScale := NSScale linear
		domain: data;
		range: { 0. 360. }.
	boxShape := RSBoxPlotShape data: data.
	boxShape scales: {xScale. yScale}.
	boxShape bandWidth: xScale rangeBand.
	boxShape bandOffset: (xScale scale: 1).

	boxShape whiskerFormat: '--'.
	self assert: boxShape whiskers border dashArray equals: #(4 2).
	boxShape computeWhiskers.
	self assert: boxShape upperWhisker border dashArray equals: #(4 2).
	self assert: boxShape lowerWhisker border dashArray equals: #(4 2).

	boxShape := RSBoxPlotShape data: data.
	boxShape whiskers format: '--'.
	boxShape scales: {xScale. yScale}.
	boxShape bandWidth: xScale rangeBand.
	boxShape bandOffset: (xScale scale: 1).
	boxShape computeWhiskers.
	self assert: boxShape upperWhisker border dashArray equals: #(4 2).
	self assert: boxShape lowerWhisker border dashArray equals: #(4 2).
]
