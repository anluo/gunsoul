function removeElement(list, obj)
   for i, v in ipairs(list) do
      if v == obj then
	 table.remove(list, i);
	 return i;
      end
   end
   return 0
end

function tostringex(v, len)
	if len == nil then len = 0 end
	local pre = string.rep('\t', len)
	local ret = ""
	if type(v) == "table" then
		if len > 10 then return "\t{ ... }" end
		local t = ""
		local keys = {}
		for k, v1 in pairs(v) do
			table.insert(keys, k)
		end
		--table.sort(keys)
		for k, v1 in pairs(keys) do
			k = v1
			v1 = v[k]
			t = t .. "\n\t" .. pre .. tostring(k) .. ":"
			t = t .. tostringex(v1, len + 1)
		end
		if t == "" then
			ret = ret .. pre .. "{ }\t(" .. tostring(v) .. ")"
		else
			if len > 0 then
				ret = ret .. "\t(" .. tostring(v) .. ")\n"
			end
			ret = ret .. pre .. "{" .. t .. "\n" .. pre .. "}"
		end
	else
		ret = ret .. pre .. tostring(v) .. "\t(" .. type(v) .. ")"
	end
	return ret
end

function split(s, delim)
	if s == nil or delim == nil then
		print(debug.traceback());
	end

	assert (type (delim) == "string" and string.len (delim) > 0,"bad delimiter")
	local start = 1  local t = {}
	while true do
		local pos = string.find (s, delim, start, true) -- plain find
		if not pos then
			break
		end
		table.insert (t, string.sub (s, start, pos - 1))
		start = pos + string.len (delim)
	end
	table.insert (t, string.sub (s, start))
	return t
end
