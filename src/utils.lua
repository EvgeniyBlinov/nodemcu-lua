local module = {}

function module:dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. module:dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

return module
