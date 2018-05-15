library(reticulate)
library(berryFunctions)
require(photon)

pycep <- import("pycep_correios") # pip install pycep_correios
urllib3 <- import("urllib3") # pip install urllib3
requests <- import("requests") # pip install requests

urllib3$disable_warnings(urllib3$exceptions$InsecureRequestWarning)

cep2coo2 <- function(cep){
  
  # Consulta do endereço através do CEP
  
  address_ = try(paste(pycep$consultar_cep(cep)$end, # endereço
                       pycep$consultar_cep(cep)$cidade, # cidade
                       "Brasil"), silent = TRUE) # país
  
  address = ifelse(is.error(address_) == T, "-", address_) # Caso CEP invalido
  
  # Consulta no Open Street Map
  
  coo <- geocode(iconv(address, from = "UTF-8", to = "ASCII//TRANSLIT"), limit = 1)[,c("lat", "lon")]
  
  return(coo)
}