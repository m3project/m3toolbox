% this is a wrapper for BinoConf_Score that returns L, U that are
% compatible with errorbar
%
% Ghaith Tarawneh (ghaith.tarawneh@ncl.ac.uk) - 28/4/2015

function [L, U] = BinoConf_ScoreB(m, n, varargin)

[Lo, Up] = BinoConf_Score(m,n,varargin{:});

L = m./n - Lo;

U = Up - m./n;

end