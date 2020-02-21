function! PythonFilename(filepath)
  return split(a:filepath, "/")[-1]
endfunction

function! PythonFileBasePath(filepath, filename)
  return join(split(a:filepath, a:filename . "$"), "")
endfunction

function! PythonFileGetTestname(filepath)
  let filename = PythonFilename(a:filepath)
  let fileBasePath = PythonFileBasePath(a:filepath, filename)

  return "tests/" . fileBasePath . "test_" . filename
endfunction

function! PythonTestGetFilename(filepath)
  let testFilename = PythonFilename(a:filepath)
  let testFileBasePath = PythonFileBasePath(a:filepath, testFilename)
  let filename = split(testFilename, "^test_")[0]
  let fileBasePath = join(split(testFileBasePath, "^tests/"), "")

  if empty(fileBasePath)
    return filename
  else
    return fileBasePath . "/" . filename
  endif
endfunction

function! PythonGetAlternateFilename(filepath)
  let fileToOpen = ""

  if empty(matchstr(a:filepath, "tests/"))
    let fileToOpen = PythonFileGetTestname(a:filepath)
  else
    let fileToOpen = PythonTestGetFilename(a:filepath)
  endif

  return fileToOpen
endfunction

function! PythonAlternateFile()
  let currentFilePath = fnamemodify(expand("%"), ":~:.")
  let fileToOpen = PythonGetAlternateFilename(currentFilePath)

  echo fileToOpen

  if filereadable(fileToOpen)
    exec(":e" . " " . fileToOpen)
  else
    echoerr "couldn't find file " . fileToOpen
  endif
endfunction
