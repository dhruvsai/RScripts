# getData <- function(url){
#     library(XML)
#     library(rvest)
#     #browser()
#     ##Find max page
#     m<-read_html(url)
#     n<-html_nodes(m,"tr")
#     l<-(lapply(n,function(x){if(!is.na(html_attr(x,"class")) && html_attr(x,"class")=="data2" && grepl("Page",html_text(x)))return(x)}))
#     l<-l[!sapply(l,is.null)]
#     t<-sapply(l,function(x)as.numeric(strsplit(strsplit(html_text(x),"Page 1 of ")[[1]][2],"\n")[[1]][1]))
#     if(length(unique(t))!=1)
#     stop("error in fetching max page number")
#     else t<- unique(t)
#     # vreadhtml <- readHTMLTable(url)
#     # names(vreadhtml)
#     # vhtmlparse <- htmlParse(url)
#     # tableNodes = getNodeSet(vhtmlparse, "//table")
#     # tb = readHTMLTable(tableNodes[[3]])
#     # tb
#     n<-html_nodes(m,xpath = "//*[@id='ciHomeContentlhs']/div[3]/table[2]/tr[1]/td[5]/a[1][@class='PaginationLink']")
#     html_attr(n,"href")
#     maxpage <- t
#     cat("maxpage=",maxpage)
#     parsedpage <- m
#     resultdf <- NULL
#     browser()
#     resultdf <- do.call(rbind,lapply(1:2,function(x){
#                                 if(grepl("page",url))
#                                 url <- gsub("(page=)+([[:digit:]])+",paste0("page=",x),url)
#                                 else url <- paste0(url,";page=",x)
#                                 browser()
#                                 parsedpage <- read_html(url)
#                                 return(parsedpage %>% html_nodes("table") %>% .[[3]] %>% html_table())
#                                 }))
#     return(resultdf)
# }

# url <- "http://stats.espncricinfo.com/ci/engine/stats/index.html?class=20;template=results;type=allround;view=ground"
# url<-"http://stats.espncricinfo.com/ci/engine/stats/index.html?class=1;home_or_away=2;opposition=25;team=5;template=results;type=fielding"
# url <- "http://stats.espncricinfo.com/ci/engine/stats/index.html?class=1;template=results;type=batting"

getData <- function(url){
  library(XML)
  library(rvest)
  resultdf <- NULL
  while(1){
    #browser()
    parsedPage <- read_html(url)
    resultdf <- rbind(resultdf,parsedPage %>% html_nodes("table") %>% .[[3]] %>% html_table())
    pageLinkNode <- html_nodes(parsedPage,xpath = "//*[@id='ciHomeContentlhs']/div[3]/table[2]/tr[1]/td[5]/a[1][@class='PaginationLink']")
    url <- html_attr(pageLinkNode,"href")
    if(length(url)<1) break
    else url <- paste0("http://stats.espncricinfo.com",url)
  }
  return(resultdf)
}