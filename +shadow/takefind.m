%TAKEFIND Search your user data folder for the most recent take.
%
%   TAKE = TAKEFIND() Looks for the last take you recorded based on its date
%   and sequence number.
%
%   [TAKE, FOLDER] = TAKEFIND() Optional output argument FOLDER contains the
%   take folder in your user data folder.
%
%   See also TAKEREAD.
%

%
% @file    +shadow/takefind.m
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

function [take, folder] = takefind()
  take = '';
  folder = [getenv('HOME'), '/Documents/Motion/take/'];
  
  listing = dir(folder);
  for i=1:length(listing)
    item = listing(length(listing) - i + 1);
    if ~item.isdir
      continue
    end

    match = regexp(item.name, '^\d{4}-\d{2}-\d{2}$', 'match');
    if isempty(match)
      continue
    end

    listing2 = dir([folder, item.name]);
    for j=[1:length(listing2)]
      item2 = listing2(length(listing2) - j + 1);
      match = regexp(item2.name, '^\d{4}$', 'match');
      if isempty(match)
        continue;
      end

      take = [item.name, '/', item2.name];
      return;
    end
  end 
end
