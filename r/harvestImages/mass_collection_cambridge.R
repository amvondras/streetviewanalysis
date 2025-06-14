# Find user to assign working directories
user.name <- Sys.info()[which(names(Sys.info())=='user')]

# collect mugshots for all of Cambridge

if (user.name == 'ejohnso4') { # Laptop
  setwd("~/GitHub/streetviewanalysis/")   
  source("~/GitHub/streetviewanalysis/r/harvestImages/functions_mugshots.R")
  source("~/Dropbox/api.key.R")
  photo.dir <- "~/Dropbox/cambridge/"
  pano.dir <- "~/Dropbox/panoramas/"
  shp.file <- "~/Dropbox/shp/buildings_with_centroids_area.shp"
  osm.dir <- "/Users/ejohnso4/Dropbox/shp/osm.cambridge/cambridgeshire-latest-free.shp/"
}
if (user.name == 'erik'){ # Server
  setwd("~/Dropbox/git/streetviewanalysis/")   
  source("~/Dropbox/git/streetviewanalysis/r/harvestImages/functions_mugshots.R")
  source("~/Dropbox/api.key.R")
  photo.dir <- "~/Dropbox/cambridge/"
  pano.dir <- "~/Dropbox/panoramas/"
  shp.file <- "~/Dropbox/shp/buildings_with_centroids_area.shp"
  osm.dir <- "/Users/ejohnso4/Dropbox/shp/osm.cambridge/cambridgeshire-latest-free.shp/"
}
if (!user.name %in% c('ejohnso4', 'erik')){ # Thies
  setwd("~/research/streetview.address/")
  source("~/research/streetviewanalysis/r/harvestImages/functions_mugshots.R")
  # Add your own API key here!
  source("~/.api.key.R")
  # api.key <- ""
  photo.dir <- "photos/cambridge/"
  pano.dir <- "streetview/panoramas/"
  shp.file <- "shp/buildings_with_centroids_area.shp"
  osm.dir <- "shp/osm.cambridge/cambridgeshire-latest-free.shp/"
}
osm.location <- paste0(osm.dir, 'osm.cambridge.rdata')
# load shapefile
s <- shapefile(shp.file)

# get an intital set of 360 endpoints in a 50m radius
ep <- createEndpoints(50, 360)

# Create a sample for mid-sized homes
#s$area <- NA
#for(i in 1:nrow(s)){
#  s$area[i] <- area( s[i,] )
#}
samp <- subset(s, area > 30 & area < 210)

# loop through all buildings
while(TRUE){
  # get a list of all pictures that have already been taken
  done <- list.files( photo.dir )
  # remove the pano information
  done <- gsub("_.+$","",done, perl=TRUE)
  
  # only keep those that have not been downloaded yet
  samp <- samp[ ! samp$TOID %in% done,]
  
  # sample a few hundred
  sampl <- samp[sample(1:nrow(samp), 100, replace=FALSE),]
  for(i in 1:nrow(sampl)){
    print(paste("Trying: ", sampl$TOID[i]))
    print(try(getMugShot(sampl$TOID[i], s, plot=FALSE, fov.ratio=1.3, endpoints=ep, api.key=api.key)))
  }
  # and do this again...
}
