# load package XML
library(XML)
library(httr)
library(reticulate)
library(berryFunctions)

pycep = import("pycep_correios")

cep2coona = function(cep, chave){

# Let's say we have a addresses
address = try(paste(pycep$consultar_cep(cep)$cidade, 
                     pycep$consultar_cep(cep)$uf, "Brasil"), silent = TRUE)

# define geocoding google api url
geo_url = "https://maps.googleapis.com/maps/api/geocode/xml?address="


# replace spaces by '+' symbols in current address
query = gsub(" ", "+", address)

# create query
geo_query = paste(geo_url, query, "&key=", chave, sep="")
doc = htmlParse(rawToChar(GET(geo_query)$content))
  
# extract latitude and longitude
lat = xpathSApply(doc, "//location//lat", xmlValue)
lon = xpathSApply(doc, "//location//lng", xmlValue)


# convert as numeric
lat = as.numeric(lat)
lon = as.numeric(lon)

# lat and lon in a matrix
lat_ = ifelse(is.error(lat) == T, NA, lat)
lon_ = ifelse(is.error(lon) == T, NA, lon)

cbind(lat = lat_, lon = lon_)
}
