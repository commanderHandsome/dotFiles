### nvim commands guide

#### Switchin buffers

<C-o> or :bp
<C-i> or :bn

#### Tests

- nmap <silent> t<C-n> :TestNearest<CR>
- nmap <silent> t<C-f> :TestFile<CR>
- nmap <silent> t<C-s> :TestSuite<CR>
- nmap <silent> t<C-l> :TestLast<CR>
- nmap <silent> t<C-g> :TestVisit<CR>


#### Code navigation

nnoremap <silent> K :call CocAction('doHover')<CR>

- nmap <silent> gd <Plug>(coc-definition)
- nmap <silent> gy <Plug>(coc-type-definition)
- nmap <silent> gi <Plug>(coc-implementation)
- nmap <silent> gr <Plug>(coc-references)

