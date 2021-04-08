function [mode, version] = takeparse(filename)
  mode = 0;
  version = 0;
  try
    doc = xmlread(filename);

    list = doc.getElementsByTagName('mode');
    if list.getLength > 0,
      mode = str2double(list.item(0).getFirstChild.getData);
    end

    list = doc.getElementsByTagName('version');
    if list.getLength > 0,
      version = str2double(list.item(0).getFirstChild.getData);
    end
  catch
    warning('Failed to read XML file %s.', filename);
  end
end
