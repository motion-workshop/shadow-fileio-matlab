%TESTSHADOWFILEIO
%
% Unit tests for the shadow fileio functions.
%

%
% @file    testShadowFileio.m
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

function tests = testShadowFileio  
  f = localfunctions();
  if exist('functiontests')
    % Matlab
    tests = functiontests(f);
    return;
  else
    % Octave
    display('--- Running testShadowFileio ---');
    tic;

    for i=1:size(f, 1)
      feval(f{i, 1});
    end
  
    toc
    display('--- Done testShadowFileio ---');
  end
end

function testTakeFind(testCase)
  filename = shadow.takefind();
  assert(exist(filename, 'file') == 2);
  assert(all(fullfile(filename) == filename));
end

function testTakeFreadHeader(testCase)
  filename = shadow.takefind();
  assert(exist(filename, 'file') == 2);

  fid = fopen(filename, 'rb', 'ieee-le');
  header = shadow.takefreadheader(fid);
  fclose(fid);

  assert(isa(header, 'struct'));
  assert(header.version > 0);
end

function testTakeRead(testCase)
  [data, header] = shadow.takeread();

  assert(ismatrix(data));

  assert(isa(header, 'struct'));
  assert(header.version > 0);
end

function testHeaderName(testCase)
  name = shadow.header.name();
  assert(isa(name, 'struct'));
  assert(name.None == 0);
end

function testHeaderRange(testCase)
  filename = shadow.takefind();
  assert(exist(filename, 'file') == 2);

  [data, header] = shadow.takeread(filename);

  assert(ismatrix(data));

  assert(isa(header, 'struct'));
  assert(header.version > 0);

  name = shadow.header.name();
  assert(isa(name, 'struct'));

  % Number of samples
  n = size(data, 1);
  
  % Time axis in seconds
  % x = linspace(0, n - 1, n) * header.h;

  % Number of nodes in the take
  m = size(header.node_header, 1);

  % For each node, query its accelerometer data (a) which may not be present
  % for all nodes in the take
  for i=1:m
    key = header.node_header(i, 1);
    a_range = shadow.header.range(header, key, name.a);
    if isempty(a_range)
      continue
    end

    % Each index into the data matrix must be a valid column 
    assert(all(a_range <= size(data, 2)));
  end
end
