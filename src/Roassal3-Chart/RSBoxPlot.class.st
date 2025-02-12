"
`RSBoxPlot` is a visual representation of the distribution of one or more datasets (one box for each dataset). It provides a visual summary of the data's spread, central tendency, and the presence of outliers.
- The box represents the interquartile range (IQR) of the data, which is the middle 50% of the dataset. It spans from the first quartile (Q1) to the third quartile (Q3).
- The central line marks the median value.
- The whiskers extend from the edges of the box and indicate the data range. The upper whisker extends to the maximum value within a certain limit (by default, 1.5 times the IQR), and the lower whisker extends to the minimum value within the same limit.
- The outliers are data points that fall outside the whiskers.

**Responsibility:**
- This class plots one or more boxes (and their corresponding whiskers and outliers) given a dataset or a collection of datasets.
- It provides options to customize the boxes (which can be accessed as `boxShapes`).
- Note: the data will be sorted by the class.

**Collaborators:** 
- **`RSBoxPlotShape`:** The instance variable `boxShapes` is a collection of `RSBoxPlotShape`. Each of these boxShapes is a box and whisker visualization which represents the distribution of a 1D dataset. Each shape also knows how to render itself.
- **`NSOrdinalScale`:** This class allows rendering each boxShape in one band by assigning the `bandWidth` and the `bandOffset`. In this way, each boxShape knows which part of the canvas it needs to fill.

**Public API and Key Messages**
- `data: aCollection` to create instances passing dataset (one or several datasets, 1D or 2D collections) as argument. 
  *Note: the `data` will be sorted by the class*
- `open` to open the visualization.
- `+ aRSBoxPlot` (returns a new `RSClusterChart`) to create a cluster chart that contains both box plots, each box plot will have a specific color for its boxes, and a cluster will be conformed by several colors. The number of clusters will be determined by how many boxes each plot has.
- `color: aColor` to change the color fill to all the boxes of the plot.
- `colors: aCollection` to change the color to each box in the plot by the color with the same index in the input collection.
- `boxShapes` returns the collection of `RSBoxPlotShape` stored in the instance variable.
- `medianLines` returns a `RSGroup` with the median lines (each one is a `RSPolyline`, lines at the median of each box) to customize the style of the lines as group or each one. (`color:`, `do:`, etc. check `RSGroup`)
- `whiskers` returns a `RSGroup` with the whisker model line (each one is a `RSPolyline`, lines extending to the most extreme, non-outlier data points) to customize the style of the lines as group or each one. (`color:`, `do:`, etc. check `RSGroup`)
- `whiskerFormat: aString` to format the whiskers line stroke and markers.
- `outliers` returns a `RSGroup` with the outlier model shape (each one is by default a `RSEllipse`) to customize the outlier points as group or each one. (`color:`, `do:`, etc. check `RSGroup`)
- `outlierMarker: aString` to change the shape of the marker (by default a `RSEllipse`).

**Instance Variables:**
- `boxShapes`: a collection of `RSBoxPlotShape`. Each of these boxShapes is a box and whisker visualization which represents the distribution of a 1D dataset. Each shape also knows how to render itself.
- `bandWidth`: a `Number` expressed in pixels (scaled) that determine the box width of every box in the plot.
- `bandOffset` a `Number` expressed in pixels (scaled) that determine an offset for all the boxes in the plot.

**Example:**
One box with one dataset (1D Collection)
```Smalltalk
| boxPlot data |
data := { 1. 2. 3. 4. 5. } .
boxPlot := RSBoxPlot data: data.
^ boxPlot open.
```

Three boxes With three datasets (2D Collection)
```Smalltalk
| boxPlot data |
data := { { 1. 2. 3. 4. 5. } .
		 { 5. 6. 7. 5. 10. }  .
		 { 12. 12. 13. 14. 15. 24. }  }.
boxPlot := self data: data.
^ boxPlot open.
```

Clustered boxes (adding plots)
```Smalltalk
| chart p1 p2 p3 y1 y2 y3 |

y1 := { { 1. 2. 3. 4. 5. } .
		 { 5. 6. 7. 5. 10. }  .
		 { 12. 12. 13. 14. 15. 24. }  }.

y2 := { { 1. 2. 2. 2. 3. 4. 3. 5. 12. } .
		 { 1. 12. 7. 10. 11. 11. 15. 10. }  .
		 { 12. 12. 13. 15. 18. 20. 21. 24. }  }.

y3 := { { 1. 2. 3. 3. 3. 5. 3. 5. 5. 7. 8. 5. 6. 10. 11. } .
		 { 12. 7. 10. 11. 11. 13. 10. 11. 12. 11. 15. 16. }  .
		 { 12. 12. 13. 15. 18. 20. 21. 24. 25. 24. 25. 26. 24. 23. 23. 25. 25. }  }.

p1 := self data: y1. ""blue""
p2 := self data: y2. ""sky blue""
p3 := self data: y3. ""orange""
chart := p1 + p2 + p3.
chart xTickLabels: { 'Day 1'. 'Day 2'. 'Day 3' }.
^ chart open.
```

The plot can be notched to represent the confidence interval around the median. There is 3 possible percentages for the interval: 90%, 95% (default one) and 99%.
Please note that the values used for 90% and 99% may not be exact due to a lack of data about it, but it is correct for 95%.

```
| y p1 p2 c size |

y :=  { {  1. 2. 3. 4. 5. 6. 7. 1. 2. 3. 4. 5. 6. 7. 1. 2. 3. 4. 5. 6. 7. 1. 2. 3. 4. 5. 6. 7. 1. 2. 3. 4. 5. 6. 7. } . { 1. 2. 3. 4. 5. 6. 7.  } }.

size := 50.

c := RSCompositeChart new.
p1 := RSBoxPlot new.
p1 y: y.
p1 notch: true.
p1 barSize: size.
p1 barOffset: size * -0.55.
p2 := RSBoxPlot new y: y.
p2 barSize: size.
p2 barOffset: size * 0.55.
c add: p1; add: p2.
c open
```
"
Class {
	#name : #RSBoxPlot,
	#superclass : #RSAbstractPlot,
	#instVars : [
		'boxShapes',
		'bandWidth',
		'offset'
	],
	#category : #'Roassal3-Chart-Core'
}

{ #category : #'instance creation' }
RSBoxPlot class >> data: aCollection [
	| boxPlot |
	boxPlot := self new.
	boxPlot data: aCollection.
	^ boxPlot
]

{ #category : #examples }
RSBoxPlot class >> exampleBoxPlot [
	| boxPlot data |
	data := { 1. 2. 3. 4. 5. } .
	boxPlot := self data: data.
	^ boxPlot open.
]

{ #category : #examples }
RSBoxPlot class >> exampleBoxPlotChangeBoxWidth [
	| boxPlot1   data1  |
	data1 := { 12. 12. 13. 14. 15. 24. }.
	boxPlot1 := self data: data1.
	boxPlot1 bandsWidth: 50.
	boxPlot1 xlabel: 'x axis'.
	boxPlot1 ylabel: 'y axis'.
	^ boxPlot1 open.
]

{ #category : #examples }
RSBoxPlot class >> exampleBoxPlotChangeSpaceBetweenBoxes [
	| clusterChart boxPlot1  boxPlot2 data1 data2  |
	data1 := { { 1. 2. 3. 4. 5. } .
			 { 5. 6. 7. 5. 10. }  .
			 { 12. 12. 13. 14. 15. 24. }  }.
	data2 := { { 1. 2. 2. 2. 3. 4. 3. 5. 12. } .
			 { 1. 12. 7. 10. 11. 11. 15. 10. }  .
			 { 12. 12. 13. 15. 18. 20. 21. 24. }  }.
	boxPlot1 := self data: data1.
	boxPlot2 := self data: data2.
	clusterChart := boxPlot1 + boxPlot2.
	
	"bandsMargin value between 0 and 1"
	clusterChart bandsMargin: 0.5.
	
	^ clusterChart open.
]

{ #category : #examples }
RSBoxPlot class >> exampleBoxPlotChangeSpaceBetweenClusters [
	| clusterChart boxPlot1  boxPlot2 data1 data2  |
	data1 := { { 1. 2. 3. 4. 5. } .
			 { 5. 6. 7. 5. 10. }  .
			 { 12. 12. 13. 14. 15. 24. }  }.
	data2 := { { 1. 2. 2. 2. 3. 4. 3. 5. 12. } .
			 { 1. 12. 7. 10. 11. 11. 15. 10. }  .
			 { 12. 12. 13. 15. 18. 20. 21. 24. }  }.
	boxPlot1 := self data: data1.
	boxPlot2 := self data: data2.
	clusterChart := boxPlot1 + boxPlot2.
	
	"clustersMargin value between 0 and 1"
	clusterChart clustersMargin: 0.5.
	
	^ clusterChart open.
]

{ #category : #examples }
RSBoxPlot class >> exampleBoxPlotCustomColor [
	| boxPlot data |
	data := { { 1. 2. 3. 4. 5. } .
			 { 5. 6. 7. 5. 10. }  .
			 { 12. 12. 13. 14. 15. 24. }  }.
	boxPlot := self data: data.
	^ boxPlot open.
]

{ #category : #examples }
RSBoxPlot class >> exampleBoxPlotGroups [
	| boxPlot boxPlot1  boxPlot2 boxPlot3 data1 data2 data3 |
	data1 := { { 1. 2. 3. 4. 5. } .
			 { 5. 6. 7. 5. 10. }  .
			 { 12. 12. 13. 14. 15. 24. }  }.
	data2 := { { 1. 2. 2. 2. 3. 4. 3. 5. 12. } .
			 { 1. 12. 7. 10. 11. 11. 15. 10. }  .
			 { 12. 12. 13. 15. 18. 20. 21. 24. }  }.
	data3 := { { 1. 2. 2. 2. 3. 4. 3. 5. 12. } .
			 { 1. 12. 7. 10. 11. 11. 15. 10. }  .
			 { 12. 12. 13. 15. 18. 20. 21. 24. }  }.
	boxPlot1 := self data: data1.
	boxPlot2 := self data: data2.
	boxPlot3 := self data: data3.
	boxPlot := boxPlot1 + boxPlot2 + boxPlot3.
	^ boxPlot open.
]

{ #category : #examples }
RSBoxPlot class >> exampleBoxPlotGroupsCustomColorPalette [
	| boxPlot boxPlot1  boxPlot2 boxPlot3 data1 data2 data3 |
	data1 := { { 1. 2. 3. 4. 5. } .
			 { 5. 6. 7. 5. 10. }  .
			 { 12. 12. 13. 14. 15. 24. }  }.
	data2 := { { 1. 2. 2. 2. 3. 4. 3. 5. 12. } .
			 { 1. 12. 7. 10. 11. 11. 15. 10. }  .
			 { 12. 12. 13. 15. 18. 20. 21. 24. }  }.
	data3 := { { 1. 2. 2. 2. 3. 4. 3. 5. 12. } .
			 { 1. 12. 7. 10. 11. 11. 15. 10. }  .
			 { 12. 12. 13. 15. 18. 20. 21. 24. }  }.
	boxPlot1 := self data: data1.
	boxPlot2 := self data: data2.
	boxPlot3 := self data: data3.
	boxPlot := boxPlot1 + boxPlot2 + boxPlot3.
	boxPlot colors: RSColorPalette qualitative accent8.
	^ boxPlot open.
]

{ #category : #examples }
RSBoxPlot class >> exampleBoxPlotGroupsEven [
	| boxPlot boxPlot1  boxPlot2 data1 data2  |
	data1 := { { 1. 2. 3. 4. 5. } .
			 { 5. 6. 7. 5. 10. }  .
			 { 12. 12. 13. 14. 15. 24. }  }.
	data2 := { { 1. 2. 2. 2. 3. 4. 3. 5. 12. } .
			 { 1. 12. 7. 10. 11. 11. 15. 10. }  .
			 { 12. 12. 13. 15. 18. 20. 21. 24. }  }.
	boxPlot1 := self data: data1.
	boxPlot2 := self data: data2.
	boxPlot := boxPlot1 + boxPlot2.
	^ boxPlot open.
]

{ #category : #examples }
RSBoxPlot class >> exampleBoxPlotGroupsEven4 [
	| boxPlot boxPlot1  boxPlot2 boxPlot3 data1 data2 boxPlot4 |
	data1 := { { 1. 2. 3. 4. 5. } .
			 { 5. 6. 7. 5. 10. }  .
			 { 12. 12. 13. 14. 15. 24. }  }.
	data2 := { { 1. 2. 2. 2. 3. 4. 3. 5. 12. } .
			 { 1. 12. 7. 10. 11. 11. 15. 10. }  .
			 { 12. 12. 13. 15. 18. 20. 21. 24. }  }.
	boxPlot1 := self data: data1.
	boxPlot2 := self data: data2.
	boxPlot3 := self data: data2.
	boxPlot4 := self data: data2.
	boxPlot := boxPlot1 + boxPlot2 + boxPlot3 + boxPlot4.
	^ boxPlot open.
]

{ #category : #examples }
RSBoxPlot class >> exampleBoxPlotGroupsOdd [
	| boxPlot boxPlot1  boxPlot2 boxPlot3 data1 data2 data3 |
	data1 := { { 1. 2. 3. 4. 5. } .
			 { 5. 6. 7. 5. 10. }  .
			 { 12. 12. 13. 14. 15. 24. }  }.
	data2 := { { 1. 2. 2. 2. 3. 4. 3. 5. 12. } .
			 { 1. 12. 7. 10. 11. 11. 15. 10. }  .
			 { 12. 12. 13. 15. 18. 20. 21. 24. }  }.
	data3 := { { 1. 2. 2. 2. 3. 4. 3. 5. 12. } .
			 { 1. 12. 7. 10. 11. 11. 15. 10. }  .
			 { 12. 12. 13. 15. 18. 20. 21. 24. }  }.
	boxPlot1 := self data: data1.
	boxPlot2 := self data: data2.
	boxPlot3 := self data: data3.
	boxPlot := boxPlot1 + boxPlot2 + boxPlot3.
	^ boxPlot open.
]

{ #category : #examples }
RSBoxPlot class >> exampleBoxPlotGroupsOdd5 [
	| boxPlot boxPlot1  boxPlot2 boxPlot3 boxPlot4 boxPlot5 data1 data2 data3 |
	data1 := { { 1. 2. 3. 4. 5. } .
			 { 5. 6. 7. 5. 10. }  .
			 { 12. 12. 13. 14. 15. 24. }  }.
	data2 := { { 1. 2. 2. 2. 3. 4. 3. 5. 12. } .
			 { 1. 12. 7. 10. 11. 11. 15. 10. }  .
			 { 12. 12. 13. 15. 18. 20. 21. 24. }  }.
	data3 := { { 1. 2. 2. 2. 3. 4. 3. 5. 12. } .
			 { 1. 12. 7. 10. 11. 11. 15. 10. }  .
			 { 12. 12. 13. 15. 18. 20. 21. 24. }  }.
	boxPlot1 := self data: data1.
	boxPlot2 := self data: data2.
	boxPlot3 := self data: data3.
	boxPlot4 := self data: data3.
	boxPlot5 := self data: data3.
	boxPlot := boxPlot1 + boxPlot2 + boxPlot3 + boxPlot4 + boxPlot5.
	^ boxPlot open.
]

{ #category : #examples }
RSBoxPlot class >> exampleBoxPlotOfMultipleDatasets [
	| boxPlot data |
	data := { { 1. 2. 3. 4. 5. } .
			 { 5. 6. 7. 5. 10. }  .
			 { 12. 12. 13. 14. 15. 24. }.
			 { 1. 10. 10. 10. 10. 12. 12. 13. 14. 15. 24. }  }.
	boxPlot := self data: data.
	^ boxPlot open.
]

{ #category : #examples }
RSBoxPlot class >> exampleBoxPlotStyleBoxFillColor [
	| boxPlot data |
	data := { { 1. 2. 3. 4. 5. } .
			 { 5. 6. 7. 5. 10. }  .
			 { 12. 12. 13. 14. 15. 24. }  }.
	boxPlot := self data: data.
	boxPlot color: Color red translucent.
	^ boxPlot open.
]

{ #category : #examples }
RSBoxPlot class >> exampleBoxPlotStyleBoxFillColorsCollection [
	| boxPlot data |
	data := { { 1. 2. 3. 4. 5. } .
			 { 5. 6. 7. 5. 10. }  .
			 { 12. 12. 13. 14. 15. 24. }  }.
	boxPlot := self data: data.
	boxPlot colors: {Color red. Color green. Color blue.}.
	^ boxPlot open.
]

{ #category : #examples }
RSBoxPlot class >> exampleBoxPlotStyleMedianLine [
	| boxPlot data |
	data := { { 1. 2. 3. 4. 5. } .
			 { 5. 6. 7. 5. 10. }  .
			 { 12. 12. 13. 14. 15. 24. }  }.
	boxPlot := self data: data.
	boxPlot medianLines do: [:ml | 
		ml dashArray: {4.}.
		ml color: Color red.
	].
	^ boxPlot open.
]

{ #category : #examples }
RSBoxPlot class >> exampleBoxPlotStyleMedianLineColor [
	| boxPlot data |
	data := { { 1. 2. 3. 4. 5. } .
			 { 5. 6. 7. 5. 10. }  .
			 { 12. 12. 13. 14. 15. 24. }  }.
	boxPlot := self data: data.
	boxPlot medianLines color: Color red.
	^ boxPlot open.
]

{ #category : #examples }
RSBoxPlot class >> exampleBoxPlotStyleOneMedianLineColor [
	| boxPlot data |
	data := { { 1. 2. 3. 4. 5. } .
			 { 5. 6. 7. 5. 10. }  .
			 { 12. 12. 13. 14. 15. 24. }  }.
	boxPlot := self data: data.
	boxPlot medianLines last color: Color red.
	(boxPlot medianLines at: 2) color: Color white.
	^ boxPlot open.
]

{ #category : #examples }
RSBoxPlot class >> exampleBoxPlotStyleOutlierShape [
	| boxPlot1  data1  |
	data1 := { { 12. 12. 13. 14. 15. 24. } .
			 { 12. 12. 13. 14. 15. 24. }  .
			 { 12. 12. 13. 14. 15. 24. }  }.
	boxPlot1 := self data: data1.
	boxPlot1 outlierMarker: '+'.
	"boxPlot1 boxShapes first outlier: (RSShapeFactory circle size: 10; color: Color red)."
	"boxPlot1 outlier: (RSShapeFactory circle size: 10; color: Color red)."
	^ boxPlot1 open.
]

{ #category : #examples }
RSBoxPlot class >> exampleBoxPlotStyleOutliersColor [
	| boxPlot boxPlot1  boxPlot2 data1 data2  |
	data1 := { { 1. 2. 3. 4. 5. } .
			 { 5. 6. 7. 5. 10. }  .
			 { 12. 12. 13. 14. 15. 24. }  }.
	data2 := { { 1. 2. 2. 2. 3. 4. 3. 5. 12. } .
			 { 1. 12. 7. 10. 11. 11. 15. 10. }  .
			 { 12. 12. 13. 15. 18. 20. 21. 24. }  }.
	boxPlot1 := self data: data1.
	boxPlot1 outliers color: Color red.
	boxPlot2 := self data: data2.
	boxPlot2 outliers color: Color purple.
	boxPlot := boxPlot1 + boxPlot2.
	^ boxPlot open.
]

{ #category : #examples }
RSBoxPlot class >> exampleBoxPlotStyleWhiskerFormat [
	| boxPlot boxPlot1 data1 data2 boxPlot2 |
	data1 := { { 1. 2. 3. 4. 5. } .
			 { 5. 6. 7. 5. 10. }  .
			 { 12. 12. 13. 14. 15. 24. }  }.
	data2 := { { 1. 2. 2. 2. 3. 4. 3. 5. 12. } .
			 { 1. 12. 7. 10. 11. 11. 15. 10. }  .
			 { 12. 12. 13. 15. 18. 20. 21. 24. }  }.
	boxPlot1 := self data: data1.
	boxPlot2 := self data: data2.
	boxPlot1 whiskerFormat: '--'.
	boxPlot2 whiskers do: [ :whiskerLine | whiskerLine format: '.'].
	boxPlot := boxPlot1 + boxPlot2.
	^ boxPlot open.
]

{ #category : #examples }
RSBoxPlot class >> exampleDays [
	| chart p1 p2 p3 y1 y2 y3 |

	y1 := { { 1. 2. 3. 4. 5. } .
			 { 5. 6. 7. 5. 10. }  .
			 { 12. 12. 13. 14. 15. 24. }  }.

	y2 := { { 1. 2. 2. 2. 3. 4. 3. 5. 12. } .
			 { 1. 12. 7. 10. 11. 11. 15. 10. }  .
			 { 12. 12. 13. 15. 18. 20. 21. 24. }  }.

	y3 := { { 1. 2. 3. 3. 3. 5. 3. 5. 5. 7. 8. 5. 6. 10. 11. } .
			 { 12. 7. 10. 11. 11. 13. 10. 11. 12. 11. 15. 16. }  .
			 { 12. 12. 13. 15. 18. 20. 21. 24. 25. 24. 25. 26. 24. 23. 23. 25. 25. }  }.

	p1 := self data: y1. "blue"
	p2 := self data: y2. "sky blue"
	p3 := self data: y3. "orange"
	chart := p1 + p2 + p3.
	chart xTickLabels: { 'Day 1'. 'Day 2'. 'Day 3' }.
	^ chart open.
]

{ #category : #examples }
RSBoxPlot class >> exampleDaysShowBands [
	| chart p1 p2 p3 y1 y2 y3 |

	y1 := { { 1. 2. 3. 4. 5. } .
			 { 5. 6. 7. 5. 10. }  .
			 { 12. 12. 13. 14. 15. 24. }  }.

	y2 := { { 1. 2. 2. 2. 3. 4. 3. 5. 12. } .
			 { 1. 12. 7. 10. 11. 11. 15. 10. }  .
			 { 12. 12. 13. 15. 18. 20. 21. 24. }  }.

	y3 := { { 1. 2. 3. 3. 3. 5. 3. 5. 5. 7. 8. 5. 6. 10. 11. } .
			 { 12. 7. 10. 11. 11. 13. 10. 11. 12. 11. 15. 16. }  .
			 { 12. 12. 13. 15. 18. 20. 21. 24. 25. 24. 25. 26. 24. 23. 23. 25. 25. }  }.

	p1 := self data: y1. "blue"
	p1 showBands.
	p2 := self data: y2. "sky blue"
	p2 showBands.
	p3 := self data: y3. "orange"
	p3 showBands.
	chart := p1 + p2 + p3.
	chart xTickLabels: { 'Day 1'. 'Day 2'. 'Day 3' }.
	^ chart open.
]

{ #category : #examples }
RSBoxPlot class >> exampleNotch [
	| p1 y1 |

	"y1 := { { 12. 12. 13. 14. 15. 24. }  }."
	y1 := { 12. 12. 13. 15. 18. 20. 21. 24. }.
	p1 := self data: y1. "blue"
	p1 notch: true.
	^ p1 open.
]

{ #category : #examples }
RSBoxPlot class >> exampleSetYTicksLabels [
	| p1 y1 |

	y1 := { { 1. 2. 3. 4. 5. } .
			 { 5. 6. 7. 5. 10. }  .
			 { 12. 12. 13. 14. 15. 24. }  }.

	p1 := self data: y1. "blue"
	p1 xTickLabels: { 'Day 1'. 'Day 2'. }.
	^ p1 open.
]

{ #category : #rendering }
RSBoxPlot >> bandsOffset: aNumberInRange [
	offset := aNumberInRange
]

{ #category : #rendering }
RSBoxPlot >> bandsWidth: aNumber [
	bandWidth := aNumber.
]

{ #category : #rendering }
RSBoxPlot >> beforeRenderingIn: aChart [
	| bandScale horizontalTicks |
	super beforeRenderingIn: aChart.
	horizontalTicks := (decorations select: [ :dec | dec isHorizontalTick ]).
	horizontalTicks isNotEmpty ifTrue: [ horizontalTicks first configuration numberOfTicks: xValues size. ].
	xScale class = NSOrdinalScale ifTrue: [ ^ self ].
	bandScale := NSScale ordinal
		domain: xValues;
		rangeBands: { 0. aChart extent x. }.
	aChart xScale: bandScale.
]

{ #category : #rendering }
RSBoxPlot >> boxShapes [
	^ boxShapes.
]

{ #category : #rendering }
RSBoxPlot >> boxShapes: collectionOfRSBoxPlotShape [
	boxShapes := collectionOfRSBoxPlotShape.
]

{ #category : #rendering }
RSBoxPlot >> boxes [
	^ RSGroup new addAll: (boxShapes collect: [ :boxShape | boxShape box ]); yourself.
]

{ #category : #public }
RSBoxPlot >> buildChart [
	chart add: self.
	chart
		extent: 360 @ 300;
		padding: 15.
	^ chart
]

{ #category : #testing }
RSBoxPlot >> canHandleCluster [
	^ true
]

{ #category : #accessing }
RSBoxPlot >> color: aColor [
	boxShapes do: [ :boxShape | boxShape color: aColor ].
]

{ #category : #accessing }
RSBoxPlot >> colors: collectionOfColors [
	boxShapes doWithIndex: [ :boxShape :idx | boxShape color: (collectionOfColors at: idx) ].
]

{ #category : #rendering }
RSBoxPlot >> computeBandsOffset [
	boxShapes doWithIndex: [ :boxShape :idx |
		boxShape bandOffset: (xScale scale: (xValues at: idx)) + offset
	].
]

{ #category : #rendering }
RSBoxPlot >> computeBandsWidth [
	boxShapes do: [ :boxShape | boxShape bandWidth: bandWidth ].
]

{ #category : #accessing }
RSBoxPlot >> computeBoxGraphicsCenters [
	| lastBoxCenter |
	lastBoxCenter := 1.
	self boxShapes: (boxShapes collect: [ :boxGraph | 
		boxGraph graphCenter: lastBoxCenter "+groupOffset".
		"lastBoxCenter := lastBoxCenter + self defaultOffset".
		boxGraph.
	]).
]

{ #category : #rendering }
RSBoxPlot >> computeDefualtXTicks [
	self horizontalTick ticks ifNil: [ self xTickLabels: (1 to: self numberOfBoxes) ].
]

{ #category : #private }
RSBoxPlot >> computeState [
	self computeXValues.
	self computeYValues.
]

{ #category : #rendering }
RSBoxPlot >> computeXValues [
	xValues := (1 to: self numberOfBoxes).
]

{ #category : #rendering }
RSBoxPlot >> computeYValues [
	| yMax yMin |
	yMax := (boxShapes collect: [ :boxShape | boxShape maxYValue ]) max.
	yMin := (boxShapes collect: [ :boxGraph | boxGraph minYValue ]) min.
	yValues := {yMin. yMax.}.
]

{ #category : #accessing }
RSBoxPlot >> confidenceInterval [
	^ self confidenceIntervals first
]

{ #category : #accessing }
RSBoxPlot >> confidenceIntervals [
	^ boxShapes collect: [ :boxShape | boxShape confidenceInterval ]
]

{ #category : #accessing }
RSBoxPlot >> confidencePercentage [
	^ boxShapes collect: [ :boxShape | boxShape confidencePercentage ]
]

{ #category : #accessing }
RSBoxPlot >> confidencePercentage: aPercentage [
	boxShapes do: [ :boxShape | boxShape confidencePercentage: aPercentage ].
]

{ #category : #accessing }
RSBoxPlot >> createdShapes [
	^ { self boxShapes. }
]

{ #category : #rendering }
RSBoxPlot >> data: aCollection [
	| collectionOfDatasets |
	
	"if is not a collection of collections. transform in a collection of collections"
	collectionOfDatasets := aCollection first isCollection
		                        ifFalse: [ { aCollection } ]
		                        ifTrue: [ aCollection ].
	self boxShapes: (collectionOfDatasets collect: [ :dataSet | RSBoxPlotShape data: dataSet.]).
	self computeBoxGraphicsCenters.
	self computeState.
]

{ #category : #accessing }
RSBoxPlot >> defaultBandsWidth [
	^ xScale scale: 1
]

{ #category : #accessing }
RSBoxPlot >> defaultOffset [
	^ xScale scale: 0
]

{ #category : #initialization }
RSBoxPlot >> defaultShape [
	^ RSPolygon new noPaint.
]

{ #category : #rendering }
RSBoxPlot >> iqr [
	^ self iqrs first.
]

{ #category : #rendering }
RSBoxPlot >> iqrs [
	^ boxShapes collect: [ :box | box iqr ].
]

{ #category : #testing }
RSBoxPlot >> isBoxPlot [
	^ true
]

{ #category : #rendering }
RSBoxPlot >> median [
	^ self medians first.
]

{ #category : #accessing }
RSBoxPlot >> medianConfidenceInterval [
	^ self medianConfidenceIntervals first
]

{ #category : #accessing }
RSBoxPlot >> medianConfidenceIntervals [
	^ boxShapes collect: [ :boxShape | boxShape medianConfidenceInterval ]
]

{ #category : #rendering }
RSBoxPlot >> medianLines [
	^ RSGroup new addAll: (boxShapes collect: [ :box | box medianLine ]); yourself.
]

{ #category : #rendering }
RSBoxPlot >> medians [
	^ boxShapes collect: [ :box | box median ].
]

{ #category : #accessing }
RSBoxPlot >> notch: aBool [
	boxShapes do: [ :boxShape | boxShape notch: aBool ].	
]

{ #category : #rendering }
RSBoxPlot >> numberOfBands [
	^ self numberOfBoxes
]

{ #category : #rendering }
RSBoxPlot >> numberOfBoxes [
	^ self boxShapes size.
]

{ #category : #rendering }
RSBoxPlot >> outlier: markerShape [
	boxShapes do: [ :box | box outlier: markerShape ].
]

{ #category : #rendering }
RSBoxPlot >> outlierMarker: markerShapeString [
	boxShapes do: [ :box | box outlierMarker: markerShapeString ].
]

{ #category : #rendering }
RSBoxPlot >> outliers [
	^ RSGroup new addAll: (boxShapes collect: [ :box | box outliers ]); yourself.
]

{ #category : #accessing }
RSBoxPlot >> quartiles [
	| quartilesArray |
	quartilesArray := boxShapes collect: [ :boxShape | boxShape quartiles ].
	boxShapes size = 1 ifTrue: [ ^quartilesArray first ] ifFalse: [ quartilesArray ]
]

{ #category : #rendering }
RSBoxPlot >> renderIn: canvas [
	super renderIn: canvas.
	"self computeDefualtXTicks."
	offset ifNil: [ offset := 0 ].
	self computeBandsOffset.
	
	bandWidth ifNil: [ bandWidth := self defaultBandsWidth ].
	self computeBandsWidth.
	
	boxShapes doWithIndex: [ :aRSBoxPlotShape :idx |
		aRSBoxPlotShape color ifNil: [ aRSBoxPlotShape color: self computeColor. ].
		aRSBoxPlotShape scales: {
				self xScale.
				self yScale }.
		aRSBoxPlotShape renderIn: canvas ]
]

{ #category : #rendering }
RSBoxPlot >> showBands [
	boxShapes do: [ :box | box showBand ]
]

{ #category : #rendering }
RSBoxPlot >> whiskerFormat: aString [
	boxShapes do: [ :box | box whiskerFormat: aString ]
]

{ #category : #rendering }
RSBoxPlot >> whiskers [
	^ RSGroup new addAll: (boxShapes collect: [ :box | box whiskers ]); yourself.
]

{ #category : #accessing }
RSBoxPlot >> y: aCollection [
	self data: aCollection.
]
