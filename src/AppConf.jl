module AppConf

export conf, parseconf

conf = Dict{String,Any}()

function findeq(ln::String)
  for i = 1:length(ln)
    if ln[i] == '='
      return i
    end
  end
  return -1
end

function parseconf(file::String)
  f = open(file)
  inquotes = false
  while !eof(f)
    ln = readline(f)
    ix = findeq(ln)
    key = ln[1:ix - 1]
    val = ln[ix + 1:end]
    if isnumber(val)
      conf[key] = parse(val)
    else
      conf[key] = val
    end
  end
end

end # module
