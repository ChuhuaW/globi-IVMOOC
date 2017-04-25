library(rglobi)
library(data.table)
library(httr)
library(jsonlite)
library(lubridate)
data = read.csv("/Users/Joshua/Dropbox/Globi Visualization/TableauVis/Data for Tableau Visualization/WhoeData.csv")
url = "http://api.globalbioticinteractions.org/"
this.content = matrix("null",nrow = nrow(data),1)
#get source_taxon image
for (i in 23051:length(data$source_taxon_name)){
  tryCatch({
  path = "imagesForName/"
  taxon = droplevels(data$source_taxon_name[i])
  taxon = gsub(" ","%20",taxon) 
  path = paste(path,taxon,sep="")
  raw.result <- GET(url = url,path=path)
  this.raw.content <- rawToChar(raw.result$content)
  this.content[i] <- fromJSON(this.raw.content)$thumbnailURL
  }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
}
data=rbind(data,this.content)


#get target_taxon image
# for (i in 1:length(data$source_taxon_name)){
#   tryCatch({
#     path = "imagesForName/"
#     taxon = droplevels(data$target_taxon_name[i])
#     taxon = gsub(" ","%20",taxon) 
#     path = paste(path,taxon,sep="")
#     raw.result <- GET(url = url,path=path)
#     this.raw.content <- rawToChar(raw.result$content)
#     this.content[i] <- fromJSON(this.raw.content)$thumbnailURL
#   }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
# }

write.csv(this.content,"/Users/Joshua/Dropbox/Globi Visualization/TableauVis/Data for Tableau Visualization/sourceimageurl.csv")
