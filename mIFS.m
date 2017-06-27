function [RANKED, WEIGHT] = mIFS( X,alpha )

%mIFS: modified Infinite Feature Selection 

%DESCRIPTION

% We propose new way of forming the feature adjacency matrix that makes the IFS algorithm more powerful 
% unsupervised feature selecion problems. 
% FUNCTION:
% 
% [RANKED, WEIGHT] = mIFS( X , alpha ) computes ranks and weights
% of features for input data matrix [X,Y] using SIFS algorithm 
% 
% INPUT:
% 
% X is a n by m matrix, where n is the number of samples and m the number
% of features. 
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

% %1) Standard Deviation 
STD = std(X,[],1);
STDMatrix = bsxfun( @max, STD, STD' );
STDMatrix = STDMatrix - min(min( STDMatrix ));
sigma_ij = STDMatrix./max(max( STDMatrix ));


% % 2) RDN: Mutual Information-based redundancy of features
rdn=RDN(X);
rdn= bsxfun( @min, rdn, rdn' );
rdn = rdn - min(min( rdn ));
rdn_ij = rdn./max(max( rdn ));

%%  3) Forming the adjacency matrix 
    A=(alpha*sigma_ij)+((1-alpha)*(1-rdn_ij));



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

