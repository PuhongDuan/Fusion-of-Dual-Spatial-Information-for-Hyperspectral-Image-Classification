function u = tvreg_original(f,lambda,opt,u)

%TVREG  TV regularization solver routine.
%   u = TVREG(f,lambda,opt) approximately solves the problem
% 
%                      /
%       Min  TV(u)  +  | lambda F(K*u,f) dx,
%        u             /
%
%   where f is an MxN or MxNxP array specifying the input image, lambda is 
%   a nonnegative scalar or MxN array specifying the fidelity weight, and 
%   other parameters are given in options struct opt.  opt may contain all 
%   or any subset of the following parameters:
%
%      opt.K         2D array, the blur point spread function
%      opt.noise     string, the noise model, which can be
%                    'Gaussian' or 'L2' for the Gaussian noise model
%                    'Laplace' or 'L1'  for the Laplace noise model
%                    'Poisson'          for the Poisson noise model
%      opt.tol       convergence tolerance
%      opt.maxiter   maximum number of iterations
%      opt.gamma1    constraint weight on d = grad u
%      opt.gamma2    constraint weight on z = Ku
%      opt.plotfun   plotting callback function
%      opt.verbose   show verbose information
%
%   Option opt.plotfun should be the name of a function or a function 
%   handle.  An example plotfun is
%  
%         function myplot(state, iter, delta, u)
%         switch state
%             case 0  % Running
%                 fprintf('  Iter=%4d  Delta=%7.3f\n', iter, delta);
%             case 1  % Converged successfully
%                 fprintf('Converged successfully.\n');
%             case 2  % Maximum iterations exceeded
%                 fprintf('Maximum number of iterations exceeded.\n');
%         end
%         image(u*255);
%         axis image
%         title(sprintf('Iter=%d  Delta=%.4f', iter, delta));
%         return;
%        
%   TVREG(f,lambda,opt,u0) specifies the initial guess u0.  By default, the
%   initialization u0 = f is used.
%
%   The minimization is solved with the split Bregman method,
%      T. Goldstein and S. Osher,  "The Split Bregman Algorithm for L1
%      Regularized Problems", UCLA CAM Report 08-29.
%
%   See also tvdenoise, tvdeconv, tvinpaint, and tvrestore.


% Implementation notes:
%
% This is the pure M-code version of the solver.  It is "functionally
% equivalent" to the MEX function version in tvreg.c, meaning for the same
% input parameters, they should converge to similar solutions.  However, 
% the two versions do not always use the same algorithm.  The changes are
% to adjust to the limitations of the MATLAB environment.
%
% For the u-subproblem when K is identity (i.e., denoising or inpainting), 
% we use Jacobi iteration here instead of Gauss-Seidel.  Gauss-Seidel could
% be implemented directly as a loop, in which case efficiency depends on
% the accelerated interpreter.  Another possibility is to use sparse matrix
% operations.  But here for simplicity we use Jacobi, which is easily
% vectorized.
%
% For the u-subproblem when K is symmetric, it can be efficiently solved
% using DCT transforms, but it is not possible here.  The functions "dct2"
% and "idct2" are only available with the Image Toolbox, and sadly, they 
% are implemented naively, using symmetric extension followed by FFT!  This
% undermines the efficiency that we would gain with the DCT.  Here we use
% the FFT for all deconvolution problems.


% 
% Input parsing
%

% Check first two arguments f and lambda
if nargin < 2
    error('Not enough input argments.');
elseif (~isnumeric(f) && ~islogical(f)) || ndims(f) > 3
    error('First argument must be a numeric 2D or 3D array.');
elseif (~isnumeric(lambda) && ~islogical(lambda)) ...
    || (numel(lambda) ~= 1 && ndims(lambda) ~= 2)
    error('Second argument must be a numeric scalar or 2D array.');
elseif numel(lambda) ~= 1 && ~isequal(size(lambda),[size(f,1),size(f,2)])
    error('lambda must have the same number of rows and columns as the input image.');
end

if nargin < 4
    if nargin < 3
        opt = struct([]);
    end
    
    u = f;
end
   
% Set defaults
K = 1;  %[ ]
noise = 'l2';
tol = 1e-3; %original tol 1e-3
maxiter = 50; %original maxiter 100
gamma1 = 5;%%%%%%%%%%%%%%%5
gamma2 = 8;%%%%%%%%%%%%%%%%%8;
plotfun = [];
verbose = 0;

% Unpack opt struct
unpackopt(opt);

% Check scalar parameters
if ~isnumericscalar(tol)
    error('tol should be a numeric scalar.');
elseif ~isnumericscalar(maxiter)
    error('maxiter should be a numeric scalar.');
elseif ~isnumericscalar(gamma1)
    error('gamma1 should be a numeric scalar.');
elseif ~isnumericscalar(gamma2)
    error('gamma2 should be a numeric scalar.');
end

% Check K
if ~isempty(K)
    if (~isnumeric(K) && ~islogical(K)) || ndims(K) ~= 2
        error('K must be a numeric 2D array.');
    elseif sum(K(:)) == 0
        error('K must have nonzero sum.');
    end
end

% Check noise
if ~ischar(noise)
    error('noise model must be a string.');
else
    switch lower(noise)
        case {'l2','l^2','gaussian'}
            noise = '2';
        case {'l1','l^1','laplace','laplacian'}
            noise = '1';
        case {'poisson'}        
            noise = 'p';
            f = max(0,f);
            u = max(0,u);
        otherwise
            error('Unknown noise model ''%s''.',noise);
    end
end

% Check plotfun
if ~isempty(plotfun) && ~ischar(plotfun) ...
        && ~isa(plotfun,'function_handle')
    error('plotfun must be the name of a function or a function handle.');
end

% Check initial u
if ~isequal(size(u), size(f))
    error('u0 must have the same size as the input image.');
end

[N1,N2,N3] = size(f); %#ok<NASGU>

if isempty(K)
    fftK = ones(2*N1,2*N2);
    DeconvFlag = false;
elseif sum(K(:)) == 0
    error('K must have nonzero sum.');
else
    K = double(K);
    Kpad = zeros(2*N1,2*N2);
    [k1,k2] = size(K);
    
    if k1 > 2*N1 || k2 > 2*N2
        error('K cannot be larger than the image.');
    end
    
    Kpad([end+1-floor(k1/2):end,1:ceil(k1/2)], ...
        [end+1-floor(k2/2):end,1:ceil(k2/2)]) = K;    
    fftK = fft2(Kpad);    
    DeconvFlag = true;
end

UseZ = (noise ~= '2' || (DeconvFlag && numel(lambda) ~= 1));

if verbose > 0
    % Verbose information
    fprintf('f         : [%d x %d x %d]\n', N1, N2, N3);
    fprintf('lambda    : ');
    
    if numel(lambda) == 1
        fprintf('%g\n', lambda);
    else
        fprintf('[%d x %d]\n', size(lambda,1), size(lambda,2));
    end
    
    fprintf('K         : ');
    
    if ~DeconvFlag
        fprintf('(identity)\n');
    else
        fprintf('[%d x %d]\n', size(K,1), size(K,2));
    end
    
    fprintf('tol       : %g\n', tol);
    fprintf('max iter  : %d\n', maxiter);
    fprintf('gamma1    : %g\n', gamma1);
    fprintf('gamma2    : %g\n', gamma2);
    fprintf('noise     : ');
    
    switch noise
        case '2'
            fprintf('L2\n');
        case '1'
            fprintf('L1\n');
        case 'p'
            fprintf('Poisson\n');
    end
    
    fprintf('plotting  : ');
    
    if isempty(plotfun)
        fprintf('none\n');
    else
        fprintf('custom\n');
    end

    fprintf('algorithm : split Bregman ');
    
    if UseZ
        fprintf('(d = grad u, z = Ku) ');
    else
        fprintf('(d = grad u) ');
    end
        
    if ~DeconvFlag
        fprintf('Gauss-Seidel ');
    else
        fprintf('Fourier ');
    end
    
    fprintf('u-solver\n');
    fprintf('implement : M-code\n');
end


%
% Initializations
%

f = double(f);
u = double(u);
dx = zeros(size(f));
dy = zeros(size(f));
dtildex = zeros(size(f));
dtildey = zeros(size(f));
iter = 0;

id = [2:N1,N1];
iu = [1,1:N1-1];
ir = [2:N2,N2];
il = [1,1:N2-1];

normf = norm(f(:));
f_0 = f;

if DeconvFlag
    Lap = zeros(2*N1,2*N2);
    Lap([end,1,2],[end,1,2]) = [0,1,0;1,-4,1;0,1,0];
end

delta = (tol + (tol == 0))*1000;

% if ~isempty(plotfun)
%     feval(plotfun, 0, iter, delta, u);
%     drawnow;
% end

if ~UseZ
    %
    % Simplified algorithm for Gaussian noise model and no inpainting
    %

    if DeconvFlag
        fftmul = ( (lambda/gamma1)*abs(fftK).^2 - real(fft2(Lap)) ).^-1;
        fftK = fftK(:,:,ones(1,N3));
        fftmul = fftmul(:,:,ones(1,N3));
        fftmKf = (lambda/gamma1)*conj(fftK).*fft2(addpad(f));
    end
    
    if numel(lambda) > 1
        lambda = lambda(:,:,ones(N3,1));
    end

    while iter < maxiter  
        %f= f+(f_0-u); %% Lee 110827
        iter = iter + 1;
        
        if DeconvFlag
            ulast = u;
            u = cutpad(real(ifft2( fftmul.*(fftmKf ...
                - fft2(addpad(dtildex - dtildex(:,il,:) ...
                + dtildey - dtildey(iu,:,:)))) )));
            udiff = norm(u(:) - ulast(:),2);
        elseif numel(lambda) == 1
            [u,udiff] = uupdate(lambda/gamma1,(lambda/gamma1)*f,...
                dtildex,dtildey,u);
        else
            unew = ((lambda/gamma1).*f - dtildex + dtildex(:,il,:) ...
                - dtildey + dtildey(iu,:,:)...
                + u(iu,:,:) + u(id,:,:) ...
                + u(:,il,:) + u(:,ir,:) + 4*u)...
                ./ (lambda/gamma1 + 8);
            udiff = norm(unew(:) - u(:),2);
            u = unew;
        end
        
        delta = udiff/normf;
        
        if iter >= 2 && delta <= tol
%             if ~isempty(plotfun)
%                 feval(plotfun, 1, iter, delta, u);
%                 drawnow;
%             end
            iter
            return;
        end

        dx = (u(:,ir,:) - u) + dx - dtildex;
        dy = (u(id,:,:) - u) + dy - dtildey;
        [dxnew,dynew] = shrink2(dx,dy,1/gamma1);

        dtildex = 2*dxnew - dx;
        dtildey = 2*dynew - dy;
        dx = dxnew;
        dy = dynew;
        
%         if ~isempty(plotfun)
%             feval(plotfun, 0, iter, delta, u);
%             drawnow;
%         end
    end
    iter
else
    %
    % General algorithm for any noise model and parameters    
    %
    
    z = u;
    b2 = zeros(size(f));
    
    if numel(lambda) > 1
        lambda = lambda(:,:,ones(N3,1));
    end

    if DeconvFlag
        fftmul = ( (gamma2/gamma1)*abs(fftK).^2 - real(fft2(Lap)) ).^-1;
        fftK = fftK(:,:,ones(1,N3));
        fftmul = fftmul(:,:,ones(1,N3));
    end
    
    % Bregman iteration main loop
    while iter < maxiter
        iter = iter + 1;
        
        % Solve the u subproblem
        if DeconvFlag
            ulast = u;
            fftu = fftmul.*( ...
                (gamma2/gamma1)*conj(fftK).*fft2(addpad(z - b2)) ...
                - fft2(addpad(dtildex - dtildex(:,il,:) ...
                + dtildey - dtildey(iu,:,:))) );
            u = cutpad(real(ifft2(fftu)));
            Ku = cutpad(real(ifft2(fftK.*fftu)));
            udiff = norm(u(:) - ulast(:),2);
        else
            [u,udiff] = uupdate(gamma2/gamma1,(gamma2/gamma1)*(z - b2),...
                dtildex,dtildey,u);
            Ku = u;
        end

        delta = udiff/normf;
        
        % Check for convergence
        if iter >= 3 && delta <= tol
            if ~isempty(plotfun)
                feval(plotfun, 1, iter, delta, u);
                drawnow;
            end
            return;
        end

        % Solve the d subproblem
        dx = (u(:,ir,:) - u) + dx - dtildex;
        dy = (u(id,:,:) - u) + dy - dtildey;
        [dxnew,dynew] = shrink2(dx,dy,1/gamma1);

        % Update Bregman variables
        dtildex = 2*dxnew - dx;
        dtildey = 2*dynew - dy;
        dx = dxnew;
        dy = dynew;

        % Solve the z subproblem
        switch noise
            case '2'
                z = (Ku + b2 + (lambda/gamma2).*f)./(1 + lambda/gamma2);
            case '1'
                z = Ku - f + b2;
                z = f + max(0,abs(z) - lambda/gamma2).*sign(z);
            case 'p'
                t = (Ku + b2 - lambda/gamma2)/2;
                z = t + sqrt(t.^2 + (lambda/gamma2).*f);
        end

        % Update Bregman variables
        b2 = b2 + Ku - z;
        
        if ~isempty(plotfun)
            feval(plotfun, 0, iter, delta, u);
            drawnow;
        end
    end
end



% Iterations exceeded maxiter
if ~isempty(plotfun)
    feval(plotfun, 2, iter, delta, u);
    drawnow;
end
return;


function unpackopt(opt)
% Unpack options struct
names = fieldnames(opt);

for k = 1:length(names)
    field = getfield(opt,names{k}); %#ok<GFLD>
    
    if isempty(field)
        continue;
    elseif isempty(strmatch(names{k},{'K', 'noise', 'tol', 'maxiter', ...
            'gamma1', 'gamma2', 'plotfun', 'verbose'}))
        warning(sprintf('Ignoring unknown option ''%s''.', ...
            names{k})); %#ok<WNTAG,SPWRN>
    else
        assignin('caller', names{k}, field);
    end
end
return;


function t = isnumericscalar(x)
% Test if variable is a numeric scalar
t = ((isnumeric(x) || islogical(x)) && numel(x) == 1);
return;


function [dx,dy] = shrink2(dx,dy,Thresh)
% Vectorial shrinkage (soft-threholding)
%   [dxnew,dynew] = SHRINK2(dx,dy,Thresh)
s = sqrt(sum(dx.^2 + dy.^2,3));
s = max(0,s - Thresh)./max(1e-12,s);
dx = s(:,:,ones(1,size(dx,3))).*dx;
dy = s(:,:,ones(1,size(dx,3))).*dy;
return;


function [unew,udiff] = uupdate(alpha,f,dx,dy,u)
% u-solver for TV restoration
%   [unew,udiff] = UUPDATE(alpha,f,dx,dy,u) approximately solves
%   alpha*u - Laplacian(u) = f - div(d)
[N1,N2,N3] = size(f); %#ok<NASGU>
id = [2:N1,N1];
iu = [1,1:N1-1];
ir = [2:N2,N2];
il = [1,1:N2-1];
unew = (f - dx + dx(:,il,:) - dy + dy(iu,:,:) ...
    + u(iu,:,:) + u(id,:,:) + u(:,il,:) + u(:,ir,:) + 4*u)/(alpha + 8);
udiff = norm(unew(:) - u(:),2);
return;


function f = addpad(f)
% Double image size in both dimensions by symmetric extension
[N1,N2,N3] = size(f); %#ok<NASGU>
f = f([1:N1,N1:-1:1],[1:N2,N2:-1:1],:);
return;


function f = cutpad(f)
% Crop an image to its top-left quarter
[N1,N2,N3] = size(f); %#ok<NASGU>
f = f(1:N1/2,1:N2/2,:);
return;

