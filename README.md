# Supervised Infinite Feature Selection

This is the MATLAB code for the feature selection methods described in https://arxiv.org/abs/1704.02665. 

## Usage 

Suppose you have a n-by-m data matrix X where n is the number of examples and m the number of features, and a n-by-1 label matrix Y, 
To run the unsupervised mIFS, issue the following command:
```
>> [RANKED, WEIGHT] = mIFS( X,alpha )
```

To run the supervised SIFS, issue the following command: 
```
>> [RANKED, WEIGHT] = SIFS( X,Y,alpha )
```

In both commands, alpha is a coefficient ranging from 0 to 1. This parameter can be set using cross-validation on training data X. 

## Remarks: 
1. To use mIFS, normalize the data using the following commands:
    ```
    >> R = bsxfun( @minus, X, min(X));
    >> R = bsxfun( @rdivide, dataR, max(dataR));
    >> features_kept = find( isnan( sum(dataR) ) | isinf( sum(dataR) ) );
    >> R(:,features_kept)=0;
    >> X=dataR;
    ```

2. To use SIFS, standardize the data using the following command: 
    ```
    >> X=zscore(trainX);
    ```
