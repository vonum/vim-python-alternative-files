function! PythonFilename(filepath)
  let filename = split(a:filepath, "/")[-1]
  echo filename
  return filename
endfunction

function! PythonFileBasePath(filepath)
  let parts = split(a:filepath, "/")
  let basepath = parts[0:len(parts)-1]
  echo basepath
  return basepath
endfunction

function! PythonFileGetTestname(filepath)
  echo "PythonFileGetTestname"
  let filename = PythonFilename(a:filepath)
  let fileBasePath = PythonFileBasePath(a:filepath)

  let value = "tests/" . fileBasePath . "/test_" . filename
  echo value
  return value
endfunction

function! PythonTestGetFilename(filepath)
  echo "PythonTestGetFilename"
  let testFilename = PythonFilename(a:filepath)
  let testFileBasePath = PythonFileBasePath(a:filepath)

  let filename = split(testFilename, "^test_")[0]
  let fileBasePath = split(testFileBasePath, "^tests/")[0]

  let value = fileBasePath . "/" filename
  echo value
  return value
endfunction

function! PythonGetAlternateFilename(filepath)
  echo "PythonGetAlternateFilename"
  let fileToOpen = ""

  if empty(matchstr(a:filepath, "tests/"))
    let fileToOpen = PythonFileGetTestname(a:filepath)
  else
    let fileToOpen = PythonTestGetFilename(a:filepath)
  endif

  return fileToOpen
endfunction

function! PythonAlternateFile()
  echo "PythonAlternateFile"
  let currentFilePath = expand(bufname("%"))
  let fileToOpen = PythonGetAlternateFilename(currentFilePath)

  echo fileToOpen

  if filereadable(fileToOpen)
    exec(":e" . " " . fileToOpen)
  else
    echoerr "couldn't find file " . fileToOpen
  endif
endfunction

nnoremap <silent><leader>pa :PA<CR>
