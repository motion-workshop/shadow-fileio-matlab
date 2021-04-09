# Shadow File IO for Matlab

[![Build Status](https://www.travis-ci.com/motion-workshop/shadow-fileio-matlab.svg?branch=main)](https://www.travis-ci.com/motion-workshop/shadow-fileio-matlab)

## Introduction

Matlab module to read a Shadow take.

## Quick Start

```matlab
  % Find your most recent take, read its data stream, and plot all of the data
  % in the take at once.
  plot(shadow.takeread());
```

```matlab
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
```

```matlab
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
```

## License

This project is distributed under a permissive [BSD License](LICENSE).