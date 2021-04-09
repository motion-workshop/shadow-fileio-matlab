%TAKEREAD Read take data in the mStream file format.
%
%   A = TAKEREAD(FILENAME) Reads a binary take stream file from the Motion
%   Service and writes it into the MxN matrix A where M is the number of samples
%   and N is the number of channels per samples.
%
%   Each row is one measurement in time. Each column is one channel of data for
%   one of the connected devices. The channels for one device are grouped
%   together in consecutive columns.
%
%   [A, HEADER] = TAKEREAD(...) Optional output argument HEADER contains the
%   list of devices and active channels in the data stream.
%
%   See also TAKEREADHEADER.
%

%
% @file    +shadow/takeread.m
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

function [data, header] = takeread(filename)
  narginchk(0, 1);

  if nargin < 1
    filename = 'data.mStream';
  end

  if ~ischar(filename)
    error('file name must be a string');
  end

  if exist(filename, 'file') ~= 2
    error('file not found');
  end

  fid = fopen(filename, 'rb', 'ieee-le');

  header = shadow.takefreadheader(fid);
  if header.version == 0
    fclose(fid);
    error('failed to read header from file, not in mStream format');
  end

  % Read MxN samples all at once.
  buffer = fread(fid, inf, 'float32');
  fclose(fid);

  nChannels = header.frame_stride / 4;
  if header.num_frame > 0
    mFrames = header.num_frame;
  else
    mFrames = size(buffer, 1) / nChannels;
  end

  data = reshape(buffer, nChannels, mFrames)';
end
