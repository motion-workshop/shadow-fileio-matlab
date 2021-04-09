%TAKEFREADHEADER Read the
%
%   S = TAKEFREADHEADER(FID)
%
%   See also TAKEREAD.
%

%
% @file    +shadow/takefreadheader.m
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

function [s] = takefreadheader(fid)
  narginchk(1, 1);

  if ~isnumeric(fid) || fid < 0
    error('fid name must be a non-negative integer');
  end

  s = struct();
  s.version = 0;

  % Detect the header by our take file magic bytes.
  magic = int32(fread(fid, 2, 'int32'));
  if ~isequal(magic, [-8882056; 87652969])
    % No header present, rewind.
    fseek(fid, -8, 0);
    return;
  end

  s.magic = magic;
  s.version = fread(fid, 1, 'int32');
  s.uuid = int32(fread(fid, 4, 'int32'));
  s.num_node = fread(fid, 1, 'uint32');
  s.frame_stride = fread(fid, 1, 'uint32');
  s.num_frame = fread(fid, 1, 'uint32');
  s.channel_mask = uint32(fread(fid, 1, 'uint32'));
  s.h = fread(fid, 1, 'float32');
  s.location = fread(fid, 3, 'float32');
  s.geomagnetic = fread(fid, 3, 'float32');
  s.tv_sec = fread(fid, 2, 'uint32');
  s.tv_usec = fread(fid, 1, 'uint32');
  s.flags = 0;

  num_padding = 11;
  if s.version > 2
    s.flags = fread(fid, 1, 'uint32');
    num_padding = num_padding - 1;
  end

  % Padding. Reserved to 128 bytes.
  fread(fid, num_padding, 'int32');

  % Per node header size varies on the take stream version. Version 4 and later
  % is 32 bytes with including a device UUID.
  header_size = 2;
  if s.version > 3
    header_size = 8;
  end

  % Two or more integers per node. The node key and its channel mask.
  s.node_header = uint32(fread(fid, header_size * s.num_node, 'uint32'));
  s.node_header = reshape(s.node_header, header_size, s.num_node)';
end
