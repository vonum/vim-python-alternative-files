function! PythonFilename(filepath)
  return split(a:filepath, "/")[-1]
endfunction

function! PythonFileBasePath(filepath)
  parts = split(a:filepath, "/")
  return parts[0:len(parts)-1]
endfunction

function! PythonFileGetTestname(filepath)
  let filename = PythonFilename(a:filepath)
  let fileBasePath = PythonFileBasePath(a:filepath)

  return "tests/" . fileBasePath . "/test_" . filename
endfunction

function! PythonTestGetFilename(filepath)
  let testFilename = PythonFilename(a:filepath)
  let testFileBasePath = PythonFileBasePath(a:filepath)

  let filename = split(testFilename, "^test_")[0]
  let fileBasePath = split(testFileBasePath, "^tests/")[0]

  return fileBasePath . "/" filename
endfunction

function! PythonGetAlternateFilename(filepath)
  let fileToOpen = ""

  if empty(matchstr(a:filepath, "tests/"))
    let fileToOpen = PythonTestGetFilename(a:filepath)
  else
    let fileToOpen = PythonFileGetTestname(a:filepath)
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

nnoremap <silent><leader>pa :PA<CR>
