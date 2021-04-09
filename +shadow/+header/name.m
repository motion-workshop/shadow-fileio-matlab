%NAME Get a symbolic name map for take channel.
%
%   S = name()
%

%
% @file    +shadow/+header/name.m
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

function [s] = name()
  s = struct();
  s.None       = 0;
  s.Gq         = bitshift(1, 0);
  s.Gdq        = bitshift(1, 1);
  s.Lq         = bitshift(1, 2);
  s.r          = bitshift(1, 3);
  s.la         = bitshift(1, 4);
  s.lv         = bitshift(1, 5);
  s.lt         = bitshift(1, 6);
  s.c          = bitshift(1, 7);
  s.a          = bitshift(1, 8);
  s.m          = bitshift(1, 9);
  s.g          = bitshift(1, 10);
  s.temp       = bitshift(1, 11);
  s.A          = bitshift(1, 12);
  s.M          = bitshift(1, 13);
  s.G          = bitshift(1, 14);
  s.Temp       = bitshift(1, 15);
  s.dt         = bitshift(1, 16);
  s.timestamp  = bitshift(1, 17);
  s.systime    = bitshift(1, 18);
  s.ea         = bitshift(1, 19);
  s.em         = bitshift(1, 20);
  s.eg         = bitshift(1, 21);
  s.eq         = bitshift(1, 22);
  s.ec         = bitshift(1, 23);
  s.p          = bitshift(1, 24);
  s.atm        = bitshift(1, 25);
  s.elev       = bitshift(1, 26);
  s.Bq         = bitshift(1, 27);
end
