%RANGE Find a named channel for a node by its key.
%
%   Search a take stream header for a particular node and channel. Return the
%   array of indices that can be used to query the columns in the MxN matrix
%   of data from the take stream.
%
%   A = range(HEADER, KEY, CHANNEL)
%

%
% @file    +shadow/+header/range.m
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

function [index] = range(header, key, channel)
  narginchk(3, 3);

  if ~isstruct(header)
    error('header must be a struct');
  end

  if ~isnumeric(key) || key <= 0
    error('key must be a positive integer');
  end

  if ~isnumeric(channel) || channel <= 0
    error('channel must be a positive integer');
  end

  % There are 27 named channels. Here are the number of elements per
  % channel.
  channel_dim = [
    4, 4, 4, 3, 3, 3, 3, 4, 3, 3, 3, 1, 3, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4, 
    1, 1, 4
  ];

  index = [];

  itr = 1;
  for i=1:header.num_node,
    mask_i = header.node_header(i, 2);
    if mask_i == 0,
      continue;
    end

    key_i = header.node_header(i, 1);
    for j=1:length(channel_dim),
      channel_j = bitshift(1, j - 1);
      if bitand(mask_i, channel_j),
        if (key_i == key) && (channel_j == channel),
          index = itr:itr + channel_dim(j) - 1;
          return;
        end
        itr = itr + channel_dim(j);
      end
    end
  end
end