%Graph Analysis Toolbox
%Version 1.0  27-May-2003
%
%Generating filters for space-variant graphs.
%   contour2pdf        - Function pdfImg=contour2pdf(img) inputs an RGB contour image with contours
%   ellipsefit         - Fit an ellipse to a polygon with least-square error.
%   findfilter         - Compute resampling filters for a point set.
%
%I/O on space-variant graphs.
%   importimg          - Import a Cartesian (standard) image to a 
%				 space-variant architecture.
%   showmesh           - Visualize 2D data (e.g., an image) on a graph by
%                                interpolating data across the faces of the 
%				 nodes.
%   showvoronoi        - Visualize 2D data (e.g., an image) on a graph by
%                                uniformly filling the Voronoi cell of each 
% 				 node with its value.
%   voronoicells       - Compute Voronoi information of a graph for 
%				 visualization.
%
%Data processing on graphs.
%   diffusion          - Diffuse data on a graph.
%   dirichletboundary  - Solve the combinatorial Dirichlet problem on a graph
%                                (e.g., interpolate missing data).
%   filtergraph        - Filter data on a graph.
%   findedges          - Detect edges in data on a graph.
%   imgsegment         - Segment a Cartesian (standard) image using a 
%				lattice.   
%   imgsegpyr          - Segment a Cartesian (standard) image using a 
%				pyramid.
%   isosolve           - Perform the calculations required by the 
%				isoperimetric algorithm.
%   makeweights        - Convert nodal graph data to edge weights.
%   partitiongraph     - Segment data on an arbitrary graph.
%   recursivepartition - Recursively segment data on an arbitrary graph.
%
%Generating node and edge sets for graphs.
%   addrandedges       - Add random edges to "small worldify" a graph.
%   latticepyramid     - Generate a connected pyramid from a Cartesian 
%				lattice.
%   knn                - Connect nodes to their nearest neighbors.
%   lattice            - Generate a Cartesian lattice with different 
%				connectivity.
%   logz               - Generate a point set using the w=log(z+a) function
%                               describing the macaque retinotopic map.
%   roach              - Generate the "roach" graph of Guattery and Miller.
%   triangulatepoints  - Compute an triangulated edge set for an input node 
%				set.
%
%Graph matrix generation.
%   adjacency          - Generate the adjacency matrix for a node/edge set.
%   incidence          - Generate the incidence matrix for a node/edge set.
%   laplacian          - Generate the Laplacian matrix for a node/edge set.
%
%Support functions.
%   adjtoedges         - Convert an adjacency matrix to an edge list.
%   binarysearch       - Perform a binary search of a vector.
%   circulant          - Generate a circulant matrix (similar to Toeplitz.m).
%   colorseg2bwseg     - Convert a segmentation indicated with color to a 
%				publishable (B&W) format.
%   colorseg2bwsegSV   - Convert a space-variant segmentation indicated with 
%				color to a publishable (B&W) format.
%   equalize           - Perform histogram equalization of a data vector.
%   normalize          - Normalize data (columnwise) to a specified range.
%   removeisolated     - Remove any isolated nodes in a graph.
%   rgbimg2vals        - Vectorize an RGB image.
%   segoutput          - Convert a segmentation labeling of a lattice to a 
%				better visualization.
%   segoutputSV        - Convert a segmentation labeling of an arbitrary graph 
%				to a better visualization.
