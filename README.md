# KNN_Classifier
Implementation of an app using the Corona SDK and Lua that demonstrates the principle of KNN Algorithm (using pre-clustered data).

## Background

* This project is about implementing and testing an app to simulate KKN (K- Nearest Neighbour), showing how it works allowing a user to input a target value and determine its class.

* kNN works by calculating the distance between each of the training set values and the target (unknown class) input, using some measure of distance.

* It then keeps the closest k values and uses those to determine the class of the target (by simply calculating which class has the most instances in the k set). 

* The application allows the user to select the means of voting, i.e, Simple Voting or Weighted Voting. A problem with simple voting to determine a class is that we gave equal weight to the contribution of all neighbours in the voting process.  This may not be realistic as the further away a neighbour is, the more it deviates from the real result. Therefore, to overcome this issue, a weighted voting algorithm has been determined where weights to the neighbours are allocated using the harmonic series.
  
## Distance Metrics

Distance Metrics that are used:

1. Euclidean Distance

1. Manhattan Distance

1. Chebyshev Distance

1. Cosine Similarity  

![](https://github.com/thisaldesilva/KNN_Classifier/blob/master/ss1.PNG)

![](https://github.com/thisaldesilva/KNN_Classifier/blob/master/ss2.PNG)
