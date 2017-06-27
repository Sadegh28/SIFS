function [RANKED, WEIGHT] = SIFS( X,Y,alpha )

%SIFS: Supervised Infinite Feature Selection 

%DESCRIPTION

%We present a new feature selection method that is suit-
%able for supervised problems. We build upon the
%recently proposed Infinite Feature Selection (IFS) method where feature
%subsets of all sizes (including infinity) are considered. We propose
%new way of forming the feature adjacency matrix that makes the IFS algorithm 
%applicable for supervised problems. We extensively evaluate our methods on many
%benchmark datasets, including large image-classification datasets (PAS-
%CAL VOC), and show that our methods outperform both the IFS and the
%widely used “minimum-redundancy maximum-relevancy (mRMR)” fea-
%ture selection algorithm.

% FUNCTION:
% 
% [RANKED, WEIGHT] = SIFS( X, Y , alpha ) computes ranks and weights
% of features for input data matrix [X,Y] using SIFS algorithm 
% 
% INPUT:
% 
% X is a n by m matrix, where n is the number of samples and m the number
% of features.
% Y is the class 
% alpha is a coefficient ranging from 0 to 1

% OUTPUT:
% 
% RANKED are indices of columns in F ordered by attribute importance,
% meaning RANKED(1) is the index of the most important feature.
% WEIGHT are attribute weights with large positive weights assigned 
% to important attributes. 


%REQUIREMENTS: 
%  To use SIFS, you should download and install MIToolbox from https://github.com/Craigacp/MIToolbox/archive/master.zip

%-----------------------------------------------------------------------------------------------------------

%Authors: 
% 1) Sadegh Eskandari, Department of Computer Science, University of Guilan, Rasht,Iran, 
	%email:eskandari@guilan.ac.ir

% 2) Emre Akbas, Department of Computer Engineering, Middle East Technical Unviersity, Ankara 06800, Turkey
	%email: emre@ceng.metu.edu.tr

%----------------------------------------------------------------------------------------------------------

% % 1) Spearma's rank correlation coefficient
    [ c_ij, ~ ] = corr( X, 'type','Spearman' );
    c_ij(isnan(c_ij)) = 1; % remove NaN
    c_ij(isinf(c_ij)) = 1; % remove inf


% % 2) Mutual Information of features to label
    for i=1:1:size(X,2)
        MI(i)=mi(full(X(:,i)),Y);
    end
    MI_FtoY = MI - min(min( MI ));
    MI_FtoY = MI_FtoY./max(max( MI_FtoY ));
    MI_FtoY=bsxfun( @max, MI_FtoY', MI_FtoY );


%%  3) Forming the adjacency matrix 
    A=(alpha*MI_FtoY)+((1-alpha)*(1-c_ij));



%% 4) Letting paths tend to infinite: IFS Core
I = eye( size( A ,1 )); % Identity Matrix

r = (0.9/max(eig( A ))); % Set a meaningful value for r
y = I - ( r * A );

S = inv( y ) - I; % see Gelfand's formula - convergence of the geometric series of matrices


%% 5) Estimating energy scores

WEIGHT = sum( S , 2 ); % energy scores s(i)

INF_IDX = mean ( WEIGHT ); % IFS index


%% 6) Ranking features according to s

[~ , RANKED ]= sort( WEIGHT , 'descend' );

RANKED = RANKED';
WEIGHT = WEIGHT';

end

