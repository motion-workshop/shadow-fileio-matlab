%TESTEXAMPLES
%
% Unit test runner for all of the example scripts.
%

%
% @file    testExamples.m
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

function tests = testExamples
  f = localfunctions();
  if exist('functiontests')
    % Matlab
    tests = functiontests(f);
    return;
  else
    % Octave
    display('--- Running testExamples ---');
    tic;

    for i=1:size(f, 1)
      figure;
      feval(f{i, 1});
    end
  
    toc
    display('--- Done testExamples ---');
  end
end

function testPlotAll(testCase)
  examplePlotAll();
end

function testPlotPositionTrail(testCase)
  examplePlotPositionTrail();
end

function testReadmeBasic(testCase)
  % Find your most recent take, read its data stream, and plot all of the data
  % in the take at once.
  plot(shadow.takeread());
end

function testReadmeRandom(testCase)
  % Read back the data stream and the header so we show the time axis for one
  % randomly selected channel.
  [A, header] = shadow.takeread();

  % Number of samples, one per row
  n = size(A, 1);

  % Create a time axis in seconds
  x = [0:n-1] * header.h;

  % Select a channel, one column
  y = A(:, randi(n));

  % Plot one channel over time
  plot(x, y);
end

function testReadmeRange(testCase)
  % Pick the gyroscope channel from the Hips node and create a nicer plot.
  [A, header] = shadow.takeread();

  % Node key 5 is the Hips in Shadow full body take
  key = 5;
  name = shadow.header.name();

  % Find the gyroscope measurement channel
  g_range = shadow.header.range(header, key, name.g);
  if isempty(g_range)
    error('no gyroscope measurement for the Hips node');
  end

  % Number of samples, one per row
  n = size(A, 1);

  % Create a time axis in seconds
  x = [0:n-1] * header.h;

  % Plot gyroscope data, x-y-z order in deg/s
  plot(x, A(:, g_range));
  title('Gyroscope measurements for Hips');
  xlabel('Time (s)');
  ylabel('Angular rate (deg/s)');
  legend('Hips.gx', 'Hips.gy', 'Hips.gz');
end
