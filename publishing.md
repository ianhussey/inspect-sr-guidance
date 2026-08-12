Terminal:

Change directory

```
cd ~/git/inspect-sr-guidance
```

Render the pdf 

```
quarto render
```



needed? :

```
quarto pandoc -o static/reference.docx --print-default-data-file reference.docx
```



Then update the website, which includes a link to the pdf

```
quarto publish gh-pages
```



or 

```
quarto publish gh-pages --no-render
```

preview website locally

``` 
quarto preview
```

