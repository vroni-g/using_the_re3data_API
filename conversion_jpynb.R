#script to convert jupyter notebooks into rmarkdown files
install.packages("rmarkdown")
library(rmarkdown)
input <- "/Users/veronikagrupp/Documents/RDM/interesting_stuff/using_the_re3data_API/re3data_API_medical_research_community.ipynb"
rmarkdown::convert_ipynb(input, output = xfun::with_ext(input, "Rmd"))
