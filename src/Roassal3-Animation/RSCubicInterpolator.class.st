"
TSEasing cubicIn
Cubic easing; equivalent to: TSEasing poly exponent: 3.

TSEasing cubicOut
Reverse cubic easing; equivalent to 1 - TSEasing cubicIn interpolate: (1 - t). Also equivalent to TSEasing polyOut exponent: 3.

TSEasing cubic 
TSEasing cubicInOut 
Symmetric cubic easing; scales cubicIn for t in {0. 0.5} and cubicOut for t in {0.5. 1}. 
Also equivalent to TSEasing poly exponent: 3.

"
Class {
	#name : #RSCubicInterpolator,
	#superclass : #RSEasingInterpolator,
	#category : #'Roassal3-Animation-Easing'
}

{ #category : #interpolation }
RSCubicInterpolator >> interpolateIn: t [
	^ t * t * t
]

{ #category : #interpolation }
RSCubicInterpolator >> interpolateInOut: i [
	| t |
	t := i * 2.
	^ (t <= 1
		ifTrue: [ t * t * t  ]
		ifFalse: [
			t := t - 2.
			t * t * t + 2 ])/2
]

{ #category : #interpolation }
RSCubicInterpolator >> interpolateOut: i [
	| t |
	t := i -1.
	^ t * t * t + 1
]
