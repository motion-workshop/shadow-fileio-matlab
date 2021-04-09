%EXAMPLEPLOTALL
%
% Example usage of the shadow fileio functions. Load the newest take from your
% user folder and plot a grid of all of the accelerometer measurements.
%
% Intended to show how to display one channel of data for all devices in a take
% and create a visual report.
%

%
% @file    examplePlotAll.m
% @version 4.0
%
% Copyright (c) 2021, Motion Workshop
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
%
% 1. Redistributions of source code must retain the above copyright notice,
%    this list of conditions and the following disclaimer.
%
% 2. Redistributions in binary form must reproduce the above copyright notice,
%    this list of conditions and the following disclaimer in the documentation
%    and/or other materials provided with the distribution.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.
%

function examplePlotAll()
  % Something like:
  %   '~/Documents/Motion/take/2021-04-01/0001/data.mStream'
  % Read more:
  %   https://www.motionshadow.com/data-folder
  filename = shadow.takefind();

  % Read the binary take stream format and return a matrix of data and the
  % header struct that we can use to find channels.
  [data, header] = shadow.takeread(filename);

  % Symbolic names for the channels
  name = shadow.header.name();

  % Number of samples
  n = size(data, 1);
  
  % Time axis in seconds
  x = [0:n-1] * header.h;

  % Number of nodes with data in the take
  num_node = size(header.node_header, 1);

  % If we have more than four nodes, make a grid of plots so we can see them
  subplot_rows = num_node;
  subplot_cols = 1;

  if num_node > 4
    subplot_rows = floor(num_node / 4);
    subplot_cols = 4;
  end

  % For each node, query its position data (c) which may not be present
  % for all nodes in the take
  for i=1:num_node
    % Integer key for the node in the take. Used for data lookup.
    key = header.node_header(i, 1);
    
    % Search for the node and channel. May not exist in the take an then the
    % range function returns an empty vector
    a_range = shadow.header.range(header, key, name.a);

    % No plot for nodes without an accelerometer measurement. Leaves an empty
    % space in our subplot grid
    if isempty(a_range)
      continue
    end

    subplot(subplot_rows, subplot_cols, i);
    y = data(:, a_range);
    plot(x, y);
    ylim([-2, 2]);
    xlabel('Time (s)');
    ylabel('Acceleration (g)');

    % We are not parsing the JSON take info file for the node names so we will
    % just label it by unique key
    title(sprintf('take\\_channel.key=%d', key));
  end
end
