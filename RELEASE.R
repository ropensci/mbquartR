
# Re-Build the README
devtools::build_readme()
devtools::document()

devtools::test()
devtools::run_examples()

# Do it all!
devtools::check()

#devtools::build()

# Test coverage
covr::report()

# Package check
check <- pkgcheck::pkgcheck(".")

summary(check)
print(check)


# Update the MB Quarters csv file via piggyback
# - Download the file by hand if necessary, and store
# - Only re-update as needed
#piggyback::pb_release_create(repo = "alex-koiter/mbquartR", tag = "data-backup")
#piggyback::pb_upload("DATA_TO_UPLOAD/mb_quarters.csv", tag = "data-backup",
#                     overwrite = TRUE, repo = "alex-koiter/mbquartR")



# URLs to check
# https://services.arcgis.com/mMUesHYPkXjaFGfS/arcgis/rest/services/MB_LegalDesc/FeatureServer/replicafilescache/MB_LegalDesc_-2210306150010260884.csv

# https://geoportal.gov.mb.ca/api/download/v1/items/11fa11f9015b45438d6493dcb3d8071c/csv?layers=0
#https://geoportal.gov.mb.ca/api/download/v1/items/11fa11f9015b45438d6493dcb3d8071c/shapefile?layers=0


# pkgdown checks - BUILD PACKAGE FIRST!
pkgdown::build_article("mbquartR")
pkgdown::build_article("example")

# Local preview in docs/ (which is gitignored)
pkgdown::build_site()

pkgdown::build_reference()
