local utils = {}

utils.endswith = function(str, endstr)
  local sl = string.len(str)
  local el = string.len(endstr)
  return string.sub(str, sl - el + 1, sl) == endstr
end

return utils
