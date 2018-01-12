# load package XML
library(XML)
library(httr)
library(reticulate)
library(berryFunctions)

pycep = import("pycep_correios")
urllib3 = import("urllib3")

urllib3$disable_warnings(urllib3$disable_warnings())

cep2coo = function(cep, chave){

# Let's say we have a addresses
address_ = try(paste(pycep$consultar_cep(cep)$end, 
                     pycep$consultar_cep(cep)$bairro,
                     pycep$consultar_cep(cep)$cidade, "Brasil"), silent = TRUE)

address = ifelse(is.error(address_) == T, 999, address_) # Caso CEP invalido (999)

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
