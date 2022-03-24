# extract repositories of the Earth System Sciences
library(httr)
library(xml2)

re3data_query <- list("subjects[]" = "34 Geosciences (including Geography)", "dataUploads[]"="open", "pidSystems[]"="DOI")

re3data_request <- GET("https://www.re3data.org/api/beta/repositories?", query = re3data_query) 
URLs <- xml_text(xml_find_all(read_xml(re3data_request), xpath = "//@href"))

# including other information needs some re-coding for the case that no or several results are returned for a repo's characteristic (like institution)
extract_repository_info <- function(repository_metadata_XML) {
  list(
    re3data_ID = xml_text(xml_find_all(repository_metadata_XML, "//r3d:re3data.orgIdentifier")),
    repositoryName = xml_text(xml_find_all(repository_metadata_XML, "//r3d:repositoryName")),
    #institution = xml_text(xml_find_all(repository_metadata_XML, "//r3d:institution")),
    repositoryUrl = xml_text(xml_find_all(repository_metadata_XML, "//r3d:repositoryURL")),
    description = xml_text(xml_find_all(repository_metadata_XML, "//r3d:description"))
  )
}

repository_info <- data.frame(matrix(ncol = 4, nrow = 0))
colnames(repository_info) <- c("re3data_ID", "repositoryName", "repositoryUrl", "description")

#repository_info <- data.frame(matrix(ncol = 5, nrow = 0))
#colnames(repository_info) <- c("re3data_ID", "repositoryName", "institution", "repositoryUrl", "description")

for (url in URLs) {
  repository_metadata_request <- GET(url)
  repository_metadata_XML <-read_xml(repository_metadata_request) 
  results_list <- extract_repository_info(repository_metadata_XML)
  repository_info <- rbind(repository_info, results_list)
}

head(repository_info)
