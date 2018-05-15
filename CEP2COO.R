library(reticulate)
library(berryFunctions)
library(photon)

pycep <- import("pycep_correios") # pip install pycep_correios
urllib3 <- import("urllib3") # pip install urllib3
requests <- import("requests") # pip install requests

requests$packages$urllib3$disable_warnings(urllib3$exceptions$InsecureRequestWarning)

cep2coo <- function(cep){
  
  # Consulta do endere?o atrav?s do CEP
  
  address_ = try(paste(pycep$consultar_cep(cep)$end, # endere?o
                       pycep$consultar_cep(cep)$cidade, # cidade
                       "Brasil"), silent = TRUE) # pa?s
  
  address = ifelse(is.error(address_) == T, "-", address_) # Caso CEP invalido
  
  # Consulta no Open Street Map
  
  coo <- geocode(iconv(address, from = "UTF-8", to = "ASCII//TRANSLIT"), limit = 1)[,c("lat", "lon")]
  
  return(coo)
}