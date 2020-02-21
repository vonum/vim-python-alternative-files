function! PythonFilename(filepath)
  return split(filepath, "/")[-1]
endfunction

function! PythonFileBasePath(filepath)
  parts = split(filepath, "/")
  return parts[0:len(parts)-1]
endfunction

function! PythonFileGetTestname(filepath)
  let filename = PythonFilename(filepath)
  let fileBasePath = PythonFileBasePath(filepath)

  return "tests/" . fileBasePath . "/test_" . filename
endfunction

function! PythonTestGetFilename(filepath)
  let testFilename = PythonFilename(filepath)
  let testFileBasePath = PythonFileBasePath(filepath)

  let filename = split(testFilename, "^test_")[0]
  let fileBasePath = split(testFileBasePath, "^tests/")[0]

  return fileBasePath . "/" filename
endfunction

function! PythonGetAlternateFilename(filepath)
  let fileToOpen = ""

  if empty(matchstr(filepath, "tests/"))
    let fileToOpen = PythonTestGetFilename(filepath)
  else
    let fileToOpen = PythonFileGetTestname(filepath)
  endif

  return fileToOpen
endfunction

function! PythonAlternateFile()
  let currentFilePath = expand(bufname("%"))
  let fileToOpen = PythonGetAlternateFilename(currentFilePath)

  echo fileToOpen

  if filereadable(fileToOpen)
    exec(":e" . " " . fileToOpen)
  else
    echoerr "couldn't find file " . fileToOpen
  endif
endfunction
