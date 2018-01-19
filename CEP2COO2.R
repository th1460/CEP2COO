library(reticulate)
library(berryFunctions)
require(photon)

pycep = import("pycep_correios")
urllib3 = import("urllib3")
requests = import("requests")

urllib3$disable_warnings(urllib3$exceptions$InsecureRequestWarning)

cep2coo2 <- function(cep){
  
  # Busca do endereço através do CEP
  address_ = try(paste(pycep$consultar_cep(cep)$end, 
                       pycep$consultar_cep(cep)$bairro,
                       pycep$consultar_cep(cep)$cidade, "Brasil"), silent = TRUE) 
  
  
  address = ifelse(is.error(address_) == T, "-", address_) # Caso CEP invalido
  
  # Query no OSM
  coo <- geocode(iconv(address, to = "ASCII//TRANSLIT"), limit = 1)[,c("lat", "lon")]
  
  return(coo)
}


