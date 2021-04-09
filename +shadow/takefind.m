%TAKEFIND Search your user data folder for the most recent take.
%
%   FOLDER = TAKEFIND() Looks for the last take you recorded based on its date
%   and sequence number.
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

function [folder] = takefind()
  folder = '';
  user_data_folder = [getenv('HOME'), '/Documents/Motion'];
  
  % Outer loop, search for folders that are in the 2020-04-01 date format.
  listing = dir([user_data_folder, '/take']);
  for i=1:length(listing)
    item = listing(length(listing) - i + 1);
    if ~item.isdir
      continue
    end

    match = regexp(item.name, '^\d{4}-\d{2}-\d{2}$', 'match');
    if isempty(match)
      continue
    end

    % Inner loop, search for folders that are in the 0001 number format.
    listing2 = dir([item.folder, '/', item.name]);
    for j=1:length(listing2)
      item2 = listing2(length(listing2) - j + 1);
      match = regexp(item2.name, '^\d{4}$', 'match');
      if isempty(match)
        continue;
      end

      folder = [item2.folder, '/', item2.name];
      return;
    end
  end 
end
