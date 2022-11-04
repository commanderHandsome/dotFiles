### nvim commands guide

#### Switching buffers

- <C-o> or :bp
- <C-i> or :bn

#### Tests

- nmap <silent> t\<C-n\> :TestNearest<CR>
- nmap <silent> t<C-f> :TestFile<CR>
- nmap <silent> t<C-s> :TestSuite<CR>
- nmap <silent> t<C-l> :TestLast<CR>
- nmap <silent> t<C-g> :TestVisit<CR>


#### Code navigation

- K:  CocAction('doHover')
- gd: (coc-definition)
- gy: (coc-type-definition)
- gi: (coc-implementation)
- gr: (coc-references)

