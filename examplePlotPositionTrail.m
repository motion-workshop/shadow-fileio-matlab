%EXAMPLEPLOTPOSITIONTRAIL
%
% Example usage of the shadow fileio functions. Load the newest take from your
% user folder and plot a position over time as a 3D line and derived signals
% representing angular velocity and linear acceleration for the same time
% period.
%
% Intended to show how to pick one device and find multiple measurement
% channels for analysis and then generate a visual report.
%

%
% @file    examplePlotPositionTrail.m
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

function examplePlotPositionTrail()
  % Something like:
  %   '~/Documents/Motion/take/2021-04-01/0001/data.mStream'
  % Read more:
  %   https://www.motionshadow.com/data-folder
  filename = [shadow.takefind(), '/data.mStream'];

  % Read the binary take stream format and return a matrix of data and the
  % header struct that we can use to find channels.
  [data, header] = shadow.takeread(filename);

  % Symbolic names for the channels
  name = shadow.header.name();

  % Number of samples
  n = size(data, 1);

  % Time axis in seconds
  x = linspace(0, n - 1, n) * header.h;

  % Number of nodes with data in the take
  num_node = size(header.node_header, 1);

  % For each node, query its position data (c) which may not be present
  % for all nodes in the take
  for i=1:num_node
    % Integer key for the node in the take. Used for data lookup.
    key = header.node_header(i, 1);

    % Find global delta quaternion (Gdq) channel
    Gdq_range = shadow.header.range(header, key, name.Gdq);
    if isempty(Gdq_range)
      continue;
    end

    % Find linear acceleration (la) channel
    la_range = shadow.header.range(header, key, name.la);
    if isempty(la_range)
      continue;
    end
    
    % Find positional constraint (c) channel
    c_range = shadow.header.range(header, key, name.c);
    if isempty(c_range)
      continue;
    end

    % Split out the individual axes. The c channel has 4 elements
    cw = data(:, c_range(1));
    cx = data(:, c_range(2));
    cy = data(:, c_range(3));
    cz = data(:, c_range(4));

    figure;

    subplot(1, 2, 1);
    plot3(cx, cy, cz);

    % We are not parsing the JSON take info file for the node names so we will
    % just label it by unique key
    title(
      sprintf(
        'take\\_channel.key=%d, position in cm over %.1f seconds',
        key, n * header.h));

    % Compute per sample magnitude of the angular rate
    angular_rate = zeros(n, 1);
    for j=1:n
      angular_rate(j) = norm(data(j, Gdq_range));
    end

    subplot(2, 2, 2);
    plot(x, angular_rate);
    xlabel('Time (s)')
    ylabel('|Angular rate| (rad/s)');

    % Compute per sample magnitude of the linear acceleration and convert to SI
    % units
    linear_acceleration = zeros(n, 1);
    for j=1:n
      linear_acceleration(j) = norm(data(j, la_range) * 9.80665);
    end    

    subplot(2, 2, 4);
    plot(x, linear_acceleration);
    xlabel('Time (s)')
    ylabel('|Linear acceleration| (m/s^2)');

    break;
  end
end