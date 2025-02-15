Class {
	#name : #RSClusterChartTest,
	#superclass : #TestCase,
	#category : #'Roassal3-Chart-Tests-Core'
}

{ #category : #tests }
RSClusterChartTest >> testBandsMargin [
	| data boxPlot1 boxPlot2 clusterChart bandsWidth newBandsWidth |
	
	data := #(1 2 5 36 5 12 3).
	boxPlot1 := RSBoxPlot data: data.
	boxPlot2 := RSBoxPlot data: data.
	clusterChart :=  boxPlot1 + boxPlot2.
	bandsWidth := clusterChart innerClusterScale rangeBand.
	self assert: clusterChart bandsMargin equals: clusterChart defaultClustersMargin.
	clusterChart bandsMargin: 0.3.
	newBandsWidth := clusterChart innerClusterScale rangeBand.
	self assert: clusterChart bandsMargin equals: 0.3.
	self assert: (bandsWidth > newBandsWidth).
]

{ #category : #tests }
RSClusterChartTest >> testClustersMargin [
	| data boxPlot1 boxPlot2 clusterChart clustersScaleRangeBand newClustersScaleRangeBand |
	
	data := #(1 2 5 36 5 12 3).
	boxPlot1 := RSBoxPlot data: data.
	boxPlot2 := RSBoxPlot data: data.
	clusterChart :=  boxPlot1 + boxPlot2.
	clustersScaleRangeBand := clusterChart clustersScale rangeBand.
	self assert: clusterChart clustersMargin equals: clusterChart defaultClustersMargin.
	clusterChart clustersMargin: 0.3.
	newClustersScaleRangeBand := clusterChart clustersScale rangeBand.
	self assert: clusterChart clustersMargin equals: 0.3.
	self assert: (clustersScaleRangeBand > newClustersScaleRangeBand).
]
