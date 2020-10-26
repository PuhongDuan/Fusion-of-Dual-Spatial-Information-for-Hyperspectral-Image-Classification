function u = satv(f,lambda,varargin)

%
%   D is the inpainting region (true = unknown).  D = [] disables
%   inpainting (specifies an empty inpainting region).
%
%   K is the point-spread function.  K = [] disables deconvolution
%   (specifies identity, K*u = u).
%
%   The noise parameter specifies the noise model (case insensitive):
%     'Gaussian' or 'L2'  - (default) the degradation model for additive
%                           white Gaussian noise (AWGN),
%                             f = (exact) + (Gaussian noise)
%     'Laplace' or 'L1'   - additive Laplacian noise, this model is
%                           effective for salt&pepper noise
%     'Poisson'           - each pixel is an independent Poisson random
%                           variable with mean equal to the exact value
%
%   TVRESTORE(...,tol,maxiter) specify the stopping tolerance and the
%   maximum number of iterations.
%
%   TVRESTORE(...,tol,maxiter,plotfun) specifies a plotting callback to
%   customize the display of the solution progress.  plotfun should be the
%   name of a function or a function handle.  An example plotfun is
%
%       function myplot(state, iter, delta, u)
%       switch state
%           case 0  % Running
%               fprintf('  Iter=%4d  Delta=%7.3f\n', iter, delta);
%           case 1  % Converged successfully
%               fprintf('Converged successfully.\n');
%           case 2  % Maximum iterations exceeded
%               fprintf('Maximum number of iterations exceeded.\n');
%       end
%       image(u*255);
%       axis image
%       title(sprintf('Iter=%d  Delta=%.4f', iter, delta));
%       return;
%
%   TVRESTORE(...,tol,maxiter,plotfun,u0) specifies the initial guess u0.  
%   By default, the initialization u0 = f is used.
%
%   TVRESTORE approximately solves the minimization problem
%
%                      /
%       Min  TV(u)  +  |        lambda F(K*u,f) dx
%        u             /Omega\D


% Check first two arguments f and lambda
if nargin < 2
    error('Not enough input argments.');
elseif (~isnumeric(f) && ~islogical(f)) || ndims(f) > 3
    error('First argument must be a numeric 2D or 3D array.');
elseif (~isnumeric(lambda) && ~islogical(lambda)) ...
    || (numel(lambda) ~= 1 && ndims(lambda) ~= 2)
    error('Second argument must be a numeric scalar or 2D array.');
elseif numel(lambda) ~= 1 && ~isequal(size(lambda), [size(f,1),size(f,2)])
    error('lambda must have the same number of rows and columns as the input image.');
end

if nargin == 2 || isempty(varargin)
    % Empty options struct
    opt = [];
elseif isstruct(varargin{1})
    % Options passed as third argument
    opt = varargin{1};
    maxargs = 2;
else
    % Unpack varargin into options struct
    maxargs = min(length(varargin),6);    
    opt = {'D', 'K', 'noise', 'tol', 'maxiter', 'plotfun', 'u0'};
    D = varargin{1};
    opt = cell2struct({varargin{2:maxargs}}, {opt{2:maxargs}}, 2);    

    if ~isempty(D)
        if (~islogical(D) && ~isnumeric(D)) || ndims(D) ~= 2
            error('D must be a logical or numeric 2D array.');
        elseif ~isequal(size(D), [size(f,1),size(f,2)])
            error('D must have the same number of rows and columns as the input image.');
        end

        if numel(lambda) == 1 
            lambda = repmat(lambda, size(D));
        end
        
        lambda(logical(D)) = 0;
    end
    
    maxargs = 7;
end

if length(varargin) > maxargs
    error('Too many input arguments.');
end

if isfield(opt, 'noise')
    opt.noise = lower(opt.noise);
end

% Uncomment this line to turn on verbose display
% opt.verbose = 1;



% Call the solver routine
% The forth argument (if specified) is the initial guess u0
u = tvreg_original(f, lambda, opt, varargin{maxargs:end});





