Extension { #name : #RSViolinPlotTest }

{ #category : #'*Roassal3-Chart-DataFrame' }
RSViolinPlotTest >> testModelDataFrame [
	| violinPlot aModel window |	
	aModel := AIDatasets loadToothGrowth.
	violinPlot := RSViolinPlot model: aModel.
	violinPlot data: [ :df | (df column: #len) asArray].
	window := violinPlot open.
	self assert: violinPlot model equals: aModel.
	self assert: violinPlot data equals: ((aModel column: #len) asArray).
	window delete.
]

{ #category : #'*Roassal3-Chart-DataFrame' }
RSViolinPlotTest >> testModelOfEachViolinDataSeries [
	| violinPlot window dataFrame dataSeries1 dataSeries2 |
	dataFrame := AIDatasets loadToothGrowth.
	dataSeries1 := (dataFrame select: [ :row | (row at: #dose) = 1 ]) column: #len.
	dataSeries2 := (dataFrame select: [ :row | (row at: #dose) = 2 ]) column: #len.
	violinPlot := RSViolinPlot models: {dataSeries1. dataSeries2.}.
	violinPlot data: {[ :ds1 | ds1 asArray]. [ :ds2 | ds2 asArray].}.
	window := violinPlot open.
	self assert: violinPlot models equals: {dataSeries1. dataSeries2. } asOrderedCollection.
	self assert: violinPlot data equals: {dataSeries1 asArray. dataSeries2 asArray.} asOrderedCollection.
	window delete.
]
