augroup DockerBuild
    autocmd!
    autocmd BufWritePost Dockerfile :belowright 24split | terminal docker.build
augroup END

nnoremap dkr :terminal docker.run<CR>

