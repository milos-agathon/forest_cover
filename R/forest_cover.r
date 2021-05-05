

# load libraries
library(dplyr, quietly=T)
library(ggplot2, quietly=T) 
library(rgdal, quietly=T)
library(raster, quietly=T)
library(sf, quietly=T)
library(exactextractr, quietly=T)
library(gdalUtils, quietly=T)
library(reshape2, quietly=T)

set.seed(20210429)

# define urls
#2015
u2015_1 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2015/E000N80/E000N80_PROBAV_LC100_global_v3.0.1_2015-base_Tree-CoverFraction-layer_EPSG-4326.tif"
u2015_2 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2015/W040N80/W040N80_PROBAV_LC100_global_v3.0.1_2015-base_Tree-CoverFraction-layer_EPSG-4326.tif"
u2015_3 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2015/W020N80/W020N80_PROBAV_LC100_global_v3.0.1_2015-base_Tree-CoverFraction-layer_EPSG-4326.tif"
u2015_4 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2015/E020N80/E020N80_PROBAV_LC100_global_v3.0.1_2015-base_Tree-CoverFraction-layer_EPSG-4326.tif"
u2015_5 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2015/E040N80/E040N80_PROBAV_LC100_global_v3.0.1_2015-base_Tree-CoverFraction-layer_EPSG-4326.tif"
u2015_6 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2015/E040N60/E040N60_PROBAV_LC100_global_v3.0.1_2015-base_Tree-CoverFraction-layer_EPSG-4326.tif"
u2015_7 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2015/W020N60/W020N60_PROBAV_LC100_global_v3.0.1_2015-base_Tree-CoverFraction-layer_EPSG-4326.tif"
u2015_8 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2015/E000N60/E000N60_PROBAV_LC100_global_v3.0.1_2015-base_Tree-CoverFraction-layer_EPSG-4326.tif"
u2015_9 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2015/E020N60/E020N60_PROBAV_LC100_global_v3.0.1_2015-base_Tree-CoverFraction-layer_EPSG-4326.tif"
u2015_10 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2015/W020N40/W020N40_PROBAV_LC100_global_v3.0.1_2015-base_Tree-CoverFraction-layer_EPSG-4326.tif"
u2015_11 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2015/E000N40/E000N40_PROBAV_LC100_global_v3.0.1_2015-base_Tree-CoverFraction-layer_EPSG-4326.tif"
u2015_12 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2015/E020N40/E020N40_PROBAV_LC100_global_v3.0.1_2015-base_Tree-CoverFraction-layer_EPSG-4326.tif"
u2015_13 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2015/E040N40/E040N40_PROBAV_LC100_global_v3.0.1_2015-base_Tree-CoverFraction-layer_EPSG-4326.tif"
#2016
u2016_1 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2016/E000N80/E000N80_PROBAV_LC100_global_v3.0.1_2016-conso_Tree-CoverFraction-layer_EPSG-4326.tif"
u2016_2 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2016/W040N80/W040N80_PROBAV_LC100_global_v3.0.1_2016-conso_Tree-CoverFraction-layer_EPSG-4326.tif"
u2016_3 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2016/W020N80/W020N80_PROBAV_LC100_global_v3.0.1_2016-conso_Tree-CoverFraction-layer_EPSG-4326.tif"
u2016_4 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2016/E020N80/E020N80_PROBAV_LC100_global_v3.0.1_2016-conso_Tree-CoverFraction-layer_EPSG-4326.tif"
u2016_5 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2016/E040N80/E040N80_PROBAV_LC100_global_v3.0.1_2016-conso_Tree-CoverFraction-layer_EPSG-4326.tif"
u2016_6 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2016/E040N60/E040N60_PROBAV_LC100_global_v3.0.1_2016-conso_Tree-CoverFraction-layer_EPSG-4326.tif"
u2016_7 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2016/W020N60/W020N60_PROBAV_LC100_global_v3.0.1_2016-conso_Tree-CoverFraction-layer_EPSG-4326.tif"
u2016_8 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2016/E000N60/E000N60_PROBAV_LC100_global_v3.0.1_2016-conso_Tree-CoverFraction-layer_EPSG-4326.tif"
u2016_9 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2016/E020N60/E020N60_PROBAV_LC100_global_v3.0.1_2016-conso_Tree-CoverFraction-layer_EPSG-4326.tif"
u2016_10 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2016/W020N40/W020N40_PROBAV_LC100_global_v3.0.1_2016-conso_Tree-CoverFraction-layer_EPSG-4326.tif"
u2016_11 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2016/E000N40/E000N40_PROBAV_LC100_global_v3.0.1_2016-conso_Tree-CoverFraction-layer_EPSG-4326.tif"
u2016_12 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2016/E020N40/E020N40_PROBAV_LC100_global_v3.0.1_2016-conso_Tree-CoverFraction-layer_EPSG-4326.tif"
u2016_13 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2016/E040N40/E040N40_PROBAV_LC100_global_v3.0.1_2016-conso_Tree-CoverFraction-layer_EPSG-4326.tif"
#2017
u2017_1 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2017/E000N80/E000N80_PROBAV_LC100_global_v3.0.1_2017-conso_Tree-CoverFraction-layer_EPSG-4326.tif"
u2017_2 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2017/W040N80/W040N80_PROBAV_LC100_global_v3.0.1_2017-conso_Tree-CoverFraction-layer_EPSG-4326.tif"
u2017_3 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2017/W020N80/W020N80_PROBAV_LC100_global_v3.0.1_2017-conso_Tree-CoverFraction-layer_EPSG-4326.tif"
u2017_4 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2017/E020N80/E020N80_PROBAV_LC100_global_v3.0.1_2017-conso_Tree-CoverFraction-layer_EPSG-4326.tif"
u2017_5 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2017/E040N80/E040N80_PROBAV_LC100_global_v3.0.1_2017-conso_Tree-CoverFraction-layer_EPSG-4326.tif"
u2017_6 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2017/E040N60/E040N60_PROBAV_LC100_global_v3.0.1_2017-conso_Tree-CoverFraction-layer_EPSG-4326.tif"
u2017_7 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2017/W020N60/W020N60_PROBAV_LC100_global_v3.0.1_2017-conso_Tree-CoverFraction-layer_EPSG-4326.tif"
u2017_8 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2017/E000N60/E000N60_PROBAV_LC100_global_v3.0.1_2017-conso_Tree-CoverFraction-layer_EPSG-4326.tif"
u2017_9 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2017/E020N60/E020N60_PROBAV_LC100_global_v3.0.1_2017-conso_Tree-CoverFraction-layer_EPSG-4326.tif"
u2017_10 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2017/W020N40/W020N40_PROBAV_LC100_global_v3.0.1_2017-conso_Tree-CoverFraction-layer_EPSG-4326.tif"
u2017_11 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2017/E000N40/E000N40_PROBAV_LC100_global_v3.0.1_2017-conso_Tree-CoverFraction-layer_EPSG-4326.tif"
u2017_12 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2017/E020N40/E020N40_PROBAV_LC100_global_v3.0.1_2017-conso_Tree-CoverFraction-layer_EPSG-4326.tif"
u2017_13 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2017/E040N40/E040N40_PROBAV_LC100_global_v3.0.1_2017-conso_Tree-CoverFraction-layer_EPSG-4326.tif"
#2018
u2018_1 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2018/E000N80/E000N80_PROBAV_LC100_global_v3.0.1_2018-conso_Tree-CoverFraction-layer_EPSG-4326.tif"
u2018_2 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2018/W040N80/W040N80_PROBAV_LC100_global_v3.0.1_2018-conso_Tree-CoverFraction-layer_EPSG-4326.tif"
u2018_3 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2018/W020N80/W020N80_PROBAV_LC100_global_v3.0.1_2018-conso_Tree-CoverFraction-layer_EPSG-4326.tif"
u2018_4 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2018/E020N80/E020N80_PROBAV_LC100_global_v3.0.1_2018-conso_Tree-CoverFraction-layer_EPSG-4326.tif"
u2018_5 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2018/E040N80/E040N80_PROBAV_LC100_global_v3.0.1_2018-conso_Tree-CoverFraction-layer_EPSG-4326.tif"
u2018_6 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2018/E040N60/E040N60_PROBAV_LC100_global_v3.0.1_2018-conso_Tree-CoverFraction-layer_EPSG-4326.tif"
u2018_7 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2018/W020N60/W020N60_PROBAV_LC100_global_v3.0.1_2018-conso_Tree-CoverFraction-layer_EPSG-4326.tif"
u2018_8 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2018/E000N60/E000N60_PROBAV_LC100_global_v3.0.1_2018-conso_Tree-CoverFraction-layer_EPSG-4326.tif"
u2018_9 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2018/E020N60/E020N60_PROBAV_LC100_global_v3.0.1_2018-conso_Tree-CoverFraction-layer_EPSG-4326.tif"
u2018_10 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2018/W020N40/W020N40_PROBAV_LC100_global_v3.0.1_2018-conso_Tree-CoverFraction-layer_EPSG-4326.tif"
u2018_11 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2018/E000N40/E000N40_PROBAV_LC100_global_v3.0.1_2018-conso_Tree-CoverFraction-layer_EPSG-4326.tif"
u2018_12 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2018/E020N40/E020N40_PROBAV_LC100_global_v3.0.1_2018-conso_Tree-CoverFraction-layer_EPSG-4326.tif"
u2018_13 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2018/E040N40/E040N40_PROBAV_LC100_global_v3.0.1_2018-conso_Tree-CoverFraction-layer_EPSG-4326.tif"
#2019
u2019_1 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2019/E000N80/E000N80_PROBAV_LC100_global_v3.0.1_2019-nrt_Tree-CoverFraction-layer_EPSG-4326.tif"
u2019_2 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2019/W040N80/W040N80_PROBAV_LC100_global_v3.0.1_2019-nrt_Tree-CoverFraction-layer_EPSG-4326.tif"
u2019_3 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2019/W020N80/W020N80_PROBAV_LC100_global_v3.0.1_2019-nrt_Tree-CoverFraction-layer_EPSG-4326.tif"
u2019_4 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2019/E020N80/E020N80_PROBAV_LC100_global_v3.0.1_2019-nrt_Tree-CoverFraction-layer_EPSG-4326.tif"
u2019_5 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2019/E040N80/E040N80_PROBAV_LC100_global_v3.0.1_2019-nrt_Tree-CoverFraction-layer_EPSG-4326.tif"
u2019_6 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2019/E040N60/E040N60_PROBAV_LC100_global_v3.0.1_2019-nrt_Tree-CoverFraction-layer_EPSG-4326.tif"
u2019_7 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2019/W020N60/W020N60_PROBAV_LC100_global_v3.0.1_2019-nrt_Tree-CoverFraction-layer_EPSG-4326.tif"
u2019_8 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2019/E000N60/E000N60_PROBAV_LC100_global_v3.0.1_2019-nrt_Tree-CoverFraction-layer_EPSG-4326.tif"
u2019_9 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2019/E020N60/E020N60_PROBAV_LC100_global_v3.0.1_2019-nrt_Tree-CoverFraction-layer_EPSG-4326.tif"
u2019_10 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2019/W020N40/W020N40_PROBAV_LC100_global_v3.0.1_2019-nrt_Tree-CoverFraction-layer_EPSG-4326.tif"
u2019_11 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2019/E000N40/E000N40_PROBAV_LC100_global_v3.0.1_2019-nrt_Tree-CoverFraction-layer_EPSG-4326.tif"
u2019_12 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2019/E020N40/E020N40_PROBAV_LC100_global_v3.0.1_2019-nrt_Tree-CoverFraction-layer_EPSG-4326.tif"
u2019_13 <- "https://s3-eu-west-1.amazonaws.com/vito.landcover.global/v3.0.1/2019/E040N40/E040N40_PROBAV_LC100_global_v3.0.1_2019-nrt_Tree-CoverFraction-layer_EPSG-4326.tif"

#DOWNLOAD FILES
#2015
download.file(u2015_1, basename(u2015_1), mode="wb")
download.file(u2015_2, basename(u2015_2), mode="wb")
download.file(u2015_3, basename(u2015_3), mode="wb")
download.file(u2015_4, basename(u2015_4), mode="wb")
download.file(u2015_5, basename(u2015_5), mode="wb")
download.file(u2015_6, basename(u2015_6), mode="wb")
download.file(u2015_7, basename(u2015_7), mode="wb")
download.file(u2015_8, basename(u2015_8), mode="wb")
download.file(u2015_9, basename(u2015_9), mode="wb")
download.file(u2015_10, basename(u2015_10), mode="wb")
download.file(u2015_11, basename(u2015_11), mode="wb")
download.file(u2015_12, basename(u2015_12), mode="wb")
download.file(u2015_13, basename(u2015_13), mode="wb")
download.file(u2016_1, basename(u2016_1), mode="wb")
download.file(u2016_2, basename(u2016_2), mode="wb")
download.file(u2016_3, basename(u2016_3), mode="wb")
download.file(u2016_4, basename(u2016_4), mode="wb")
download.file(u2016_5, basename(u2016_5), mode="wb")
download.file(u2016_6, basename(u2016_6), mode="wb")
download.file(u2016_7, basename(u2016_7), mode="wb")
download.file(u2016_8, basename(u2016_8), mode="wb")
download.file(u2016_9, basename(u2016_9), mode="wb")
download.file(u2016_10, basename(u2016_10), mode="wb")
download.file(u2016_11, basename(u2016_11), mode="wb")
download.file(u2016_12, basename(u2016_12), mode="wb")
download.file(u2016_13, basename(u2016_13), mode="wb")
download.file(u2017_1, basename(u2017_1), mode="wb")
download.file(u2017_2, basename(u2017_2), mode="wb")
download.file(u2017_3, basename(u2017_3), mode="wb")
download.file(u2017_4, basename(u2017_4), mode="wb")
download.file(u2017_5, basename(u2017_5), mode="wb")
download.file(u2017_6, basename(u2017_6), mode="wb")
download.file(u2017_7, basename(u2017_7), mode="wb")
download.file(u2017_8, basename(u2017_8), mode="wb")
download.file(u2017_9, basename(u2017_9), mode="wb")
download.file(u2017_10, basename(u2017_10), mode="wb")
download.file(u2017_11, basename(u2017_11), mode="wb")
download.file(u2017_12, basename(u2017_12), mode="wb")
download.file(u2017_13, basename(u2017_13), mode="wb")
download.file(u2018_1, basename(u2018_1), mode="wb")
download.file(u2018_2, basename(u2018_2), mode="wb")
download.file(u2018_3, basename(u2018_3), mode="wb")
download.file(u2018_4, basename(u2018_4), mode="wb")
download.file(u2018_5, basename(u2018_5), mode="wb")
download.file(u2018_6, basename(u2018_6), mode="wb")
download.file(u2018_7, basename(u2018_7), mode="wb")
download.file(u2018_8, basename(u2018_8), mode="wb")
download.file(u2018_9, basename(u2018_9), mode="wb")
download.file(u2018_10, basename(u2018_10), mode="wb")
download.file(u2018_11, basename(u2018_11), mode="wb")
download.file(u2018_12, basename(u2018_12), mode="wb")
download.file(u2018_13, basename(u2018_13), mode="wb")
download.file(u2019_1, basename(u2019_1), mode="wb")
download.file(u2019_2, basename(u2019_2), mode="wb")
download.file(u2019_3, basename(u2019_3), mode="wb")
download.file(u2019_4, basename(u2019_4), mode="wb")
download.file(u2019_5, basename(u2019_5), mode="wb")
download.file(u2019_6, basename(u2019_6), mode="wb")
download.file(u2019_7, basename(u2019_7), mode="wb")
download.file(u2019_8, basename(u2019_8), mode="wb")
download.file(u2019_9, basename(u2019_9), mode="wb")
download.file(u2019_10, basename(u2019_10), mode="wb")
download.file(u2019_11, basename(u2019_11), mode="wb")
download.file(u2019_12, basename(u2019_12), mode="wb")
download.file(u2019_13, basename(u2019_13), mode="wb")

# filenames
ras2015 <- c("E000N80_PROBAV_LC100_global_v3.0.1_2015-base_Tree-CoverFraction-layer_EPSG-4326.tif",
"W040N80_PROBAV_LC100_global_v3.0.1_2015-base_Tree-CoverFraction-layer_EPSG-4326.tif",
"W020N80_PROBAV_LC100_global_v3.0.1_2015-base_Tree-CoverFraction-layer_EPSG-4326.tif",
"E020N80_PROBAV_LC100_global_v3.0.1_2015-base_Tree-CoverFraction-layer_EPSG-4326.tif",
"E040N80_PROBAV_LC100_global_v3.0.1_2015-base_Tree-CoverFraction-layer_EPSG-4326.tif",
"E040N60_PROBAV_LC100_global_v3.0.1_2015-base_Tree-CoverFraction-layer_EPSG-4326.tif",
"W020N60_PROBAV_LC100_global_v3.0.1_2015-base_Tree-CoverFraction-layer_EPSG-4326.tif",
"E000N60_PROBAV_LC100_global_v3.0.1_2015-base_Tree-CoverFraction-layer_EPSG-4326.tif",
"E020N60_PROBAV_LC100_global_v3.0.1_2015-base_Tree-CoverFraction-layer_EPSG-4326.tif",
"W020N40_PROBAV_LC100_global_v3.0.1_2015-base_Tree-CoverFraction-layer_EPSG-4326.tif",
"E000N40_PROBAV_LC100_global_v3.0.1_2015-base_Tree-CoverFraction-layer_EPSG-4326.tif",
"E020N40_PROBAV_LC100_global_v3.0.1_2015-base_Tree-CoverFraction-layer_EPSG-4326.tif",
"E040N40_PROBAV_LC100_global_v3.0.1_2015-base_Tree-CoverFraction-layer_EPSG-4326.tif")

ras2016 <- c("E000N80_PROBAV_LC100_global_v3.0.1_2016-conso_Tree-CoverFraction-layer_EPSG-4326.tif",
"W040N80_PROBAV_LC100_global_v3.0.1_2016-conso_Tree-CoverFraction-layer_EPSG-4326.tif",
"W020N80_PROBAV_LC100_global_v3.0.1_2016-conso_Tree-CoverFraction-layer_EPSG-4326.tif",
"E020N80_PROBAV_LC100_global_v3.0.1_2016-conso_Tree-CoverFraction-layer_EPSG-4326.tif",
"E040N80_PROBAV_LC100_global_v3.0.1_2016-conso_Tree-CoverFraction-layer_EPSG-4326.tif",
"E040N60_PROBAV_LC100_global_v3.0.1_2016-conso_Tree-CoverFraction-layer_EPSG-4326.tif",
"W020N60_PROBAV_LC100_global_v3.0.1_2016-conso_Tree-CoverFraction-layer_EPSG-4326.tif",
"E000N60_PROBAV_LC100_global_v3.0.1_2016-conso_Tree-CoverFraction-layer_EPSG-4326.tif",
"E020N60_PROBAV_LC100_global_v3.0.1_2016-conso_Tree-CoverFraction-layer_EPSG-4326.tif",
"W020N40_PROBAV_LC100_global_v3.0.1_2016-conso_Tree-CoverFraction-layer_EPSG-4326.tif",
"E000N40_PROBAV_LC100_global_v3.0.1_2016-conso_Tree-CoverFraction-layer_EPSG-4326.tif",
"E020N40_PROBAV_LC100_global_v3.0.1_2016-conso_Tree-CoverFraction-layer_EPSG-4326.tif",
"E040N40_PROBAV_LC100_global_v3.0.1_2016-conso_Tree-CoverFraction-layer_EPSG-4326.tif")

ras2017 <- c("E000N80_PROBAV_LC100_global_v3.0.1_2017-conso_Tree-CoverFraction-layer_EPSG-4326.tif",
"W040N80_PROBAV_LC100_global_v3.0.1_2017-conso_Tree-CoverFraction-layer_EPSG-4326.tif",
"W020N80_PROBAV_LC100_global_v3.0.1_2017-conso_Tree-CoverFraction-layer_EPSG-4326.tif",
"E020N80_PROBAV_LC100_global_v3.0.1_2017-conso_Tree-CoverFraction-layer_EPSG-4326.tif",
"E040N80_PROBAV_LC100_global_v3.0.1_2017-conso_Tree-CoverFraction-layer_EPSG-4326.tif",
"E040N60_PROBAV_LC100_global_v3.0.1_2017-conso_Tree-CoverFraction-layer_EPSG-4326.tif",
"W020N60_PROBAV_LC100_global_v3.0.1_2017-conso_Tree-CoverFraction-layer_EPSG-4326.tif",
"E000N60_PROBAV_LC100_global_v3.0.1_2017-conso_Tree-CoverFraction-layer_EPSG-4326.tif",
"E020N60_PROBAV_LC100_global_v3.0.1_2017-conso_Tree-CoverFraction-layer_EPSG-4326.tif",
"W020N40_PROBAV_LC100_global_v3.0.1_2017-conso_Tree-CoverFraction-layer_EPSG-4326.tif",
"E000N40_PROBAV_LC100_global_v3.0.1_2017-conso_Tree-CoverFraction-layer_EPSG-4326.tif",
"E020N40_PROBAV_LC100_global_v3.0.1_2017-conso_Tree-CoverFraction-layer_EPSG-4326.tif",
"E040N40_PROBAV_LC100_global_v3.0.1_2017-conso_Tree-CoverFraction-layer_EPSG-4326.tif")

ras2018 <- c("E000N80_PROBAV_LC100_global_v3.0.1_2018-conso_Tree-CoverFraction-layer_EPSG-4326.tif",
"W040N80_PROBAV_LC100_global_v3.0.1_2018-conso_Tree-CoverFraction-layer_EPSG-4326.tif",
"W020N80_PROBAV_LC100_global_v3.0.1_2018-conso_Tree-CoverFraction-layer_EPSG-4326.tif",
"E020N80_PROBAV_LC100_global_v3.0.1_2018-conso_Tree-CoverFraction-layer_EPSG-4326.tif",
"E040N80_PROBAV_LC100_global_v3.0.1_2018-conso_Tree-CoverFraction-layer_EPSG-4326.tif",
"E040N60_PROBAV_LC100_global_v3.0.1_2018-conso_Tree-CoverFraction-layer_EPSG-4326.tif",
"W020N60_PROBAV_LC100_global_v3.0.1_2018-conso_Tree-CoverFraction-layer_EPSG-4326.tif",
"E000N60_PROBAV_LC100_global_v3.0.1_2018-conso_Tree-CoverFraction-layer_EPSG-4326.tif",
"E020N60_PROBAV_LC100_global_v3.0.1_2018-conso_Tree-CoverFraction-layer_EPSG-4326.tif",
"W020N40_PROBAV_LC100_global_v3.0.1_2018-conso_Tree-CoverFraction-layer_EPSG-4326.tif",
"E000N40_PROBAV_LC100_global_v3.0.1_2018-conso_Tree-CoverFraction-layer_EPSG-4326.tif",
"E020N40_PROBAV_LC100_global_v3.0.1_2018-conso_Tree-CoverFraction-layer_EPSG-4326.tif",
"E040N40_PROBAV_LC100_global_v3.0.1_2018-conso_Tree-CoverFraction-layer_EPSG-4326.tif")

ras2019 <- c("E000N80_PROBAV_LC100_global_v3.0.1_2019-nrt_Tree-CoverFraction-layer_EPSG-4326.tif",
"W040N80_PROBAV_LC100_global_v3.0.1_2019-nrt_Tree-CoverFraction-layer_EPSG-4326.tif",
"W020N80_PROBAV_LC100_global_v3.0.1_2019-nrt_Tree-CoverFraction-layer_EPSG-4326.tif",
"E020N80_PROBAV_LC100_global_v3.0.1_2019-nrt_Tree-CoverFraction-layer_EPSG-4326.tif",
"E040N80_PROBAV_LC100_global_v3.0.1_2019-nrt_Tree-CoverFraction-layer_EPSG-4326.tif",
"E040N60_PROBAV_LC100_global_v3.0.1_2019-nrt_Tree-CoverFraction-layer_EPSG-4326.tif",
"W020N60_PROBAV_LC100_global_v3.0.1_2019-nrt_Tree-CoverFraction-layer_EPSG-4326.tif",
"E000N60_PROBAV_LC100_global_v3.0.1_2019-nrt_Tree-CoverFraction-layer_EPSG-4326.tif",
"E020N60_PROBAV_LC100_global_v3.0.1_2019-nrt_Tree-CoverFraction-layer_EPSG-4326.tif",
"W020N40_PROBAV_LC100_global_v3.0.1_2019-nrt_Tree-CoverFraction-layer_EPSG-4326.tif",
"E000N40_PROBAV_LC100_global_v3.0.1_2019-nrt_Tree-CoverFraction-layer_EPSG-4326.tif",
"E020N40_PROBAV_LC100_global_v3.0.1_2019-nrt_Tree-CoverFraction-layer_EPSG-4326.tif",
"E040N40_PROBAV_LC100_global_v3.0.1_2019-nrt_Tree-CoverFraction-layer_EPSG-4326.tif")

# merge each raster into one
r2015 <- mosaic_rasters(gdalfile=ras2015,
              dst_dataset="2015_forest_cover.tif",
              of="GTiff")
r2016 <- mosaic_rasters(gdalfile=ras2016,
              dst_dataset="2016_forest_cover.tif",
              of="GTiff")
r2017 <- mosaic_rasters(gdalfile=ras2017,
              dst_dataset="2017_forest_cover.tif",
              of="GTiff")
r2018 <- mosaic_rasters(gdalfile=ras2018,
              dst_dataset="2018_forest_cover.tif",
              of="GTiff")
r2019 <- mosaic_rasters(gdalfile=ras2019,
              dst_dataset="2019_forest_cover.tif",
              of="GTiff")

# load stacked rasters
rastlist <- list.files(path = getwd(), 
	pattern='forest_cover.tif$', 
	all.files=T, 
	full.names=F)
ras <- stack(rastlist)
crs(ras) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"

#download all NUTS2019 shapefiles
url <- "https://gisco-services.ec.europa.eu/distribution/v2/nuts/download/ref-nuts-2019-01m.shp.zip"
download.file(url, basename(url), mode="wb")
unzip("ref-nuts-2019-01m.shp.zip")

#unzip NUTS0, NUTS1, NUTS2 and NUTS3 shapefiles in WGS84 coordinate system 
unzip("NUTS_RG_01M_2019_4326_LEVL_0.shp.zip")
unzip("NUTS_RG_01M_2019_4326_LEVL_1.shp.zip")
unzip("NUTS_RG_01M_2019_4326_LEVL_2.shp.zip")
unzip("NUTS_RG_01M_2019_4326_LEVL_3.shp.zip")

wd <- getwd()
shp_files <- list.files(wd, pattern = "\\.shp$")

# Batch shapefile loading function from ealfons1 #
rgdal_batch_shp <- function(shp_list) {
	layer_name <- as.character(gsub(".shp","",shp_list))
    shp_spdf <-readOGR(dsn = wd, stringsAsFactors = FALSE, verbose = TRUE, 
                         useC = TRUE, dropNULLGeometries = TRUE, addCommentsToPolygons = TRUE,
                         layer = layer_name, require_geomType = NULL,
                         p4s = NULL, encoding = 'ESRI Shapefile')
    }

batch_shp_list <- lapply(shp_files, rgdal_batch_shp)

    #--Extract each element in list into its own object
    for(i in seq(batch_shp_list))
      assign(paste("nuts_", i-1, sep = ""), batch_shp_list[[i]])

# average DN values over NUTS2016 for the first element in the list
#NUTS0
nuts_0$id <- 1:max(nrow(nuts_0)) # common id
nuts0 <- nuts_0 %>% st_as_sf()
nts0  <- exact_extract(ras, nuts0 , "mean")
nts0$id <- 1:max(nrow(nts0)) # common id
nt0 <- melt(data = nts0, id.vars = "id")

# turn variable string into date string
nt0$year <- nt0$variable %>%
           gsub("mean.X", "", .) %>%
           gsub("_forest_cover", "", .) %>%    
           as.numeric()
nl0 <- merge(nt0[,c(1, 3:4)], nuts_0, by="id")
nl0$indicator_code <- "forest_cover_data"
nl0$unit <- "percent"
nl0$month <- 1 # generic values
nl0$day <- 1 # generic values
nl0$time <- paste0(nl0$month, "/", nl0$day, "/", nl0$year)
colnames(nl0)[colnames(nl0) == "NUTS_ID"] <- "geo"
colnames(nl0)[colnames(nl0) == "date"] <- "time"
nl0$frequency <- "Y"
nl0$estimate <- "missing"
nl0$db_source <- "copernicus_forest_cover_data"

n0df <- nl0[,c("indicator_code", "unit", "geo", "time", "value",
				 "year", "month", "day", "frequency", "estimate", 
				 "db_source")]

write.csv(file="nuts0_average_forest_cover.csv", n0df, row.names=FALSE)

#NUTS1
nuts_1$id <- 1:max(nrow(nuts_1)) # common id
nuts1 <- nuts_1 %>% st_as_sf()
nts1  <- exact_extract(ras, nuts1 , "mean")
nts1$id <- 1:max(nrow(nts1)) # common id
nt1 <- melt(data = nts1, id.vars = "id")

# turn variable string into date string
nt1$year <- nt1$variable %>%
           gsub("mean.X", "", .) %>%
           gsub("_forest_cover", "", .) %>%    
           as.numeric()
nl1 <- merge(nt1[,c(1, 3:4)], nuts_1, by="id")
nl1$indicator_code <- "forest_cover_data"
nl1$unit <- "percent"
nl1$month <- 1 # generic values
nl1$day <- 1 # generic values
nl1$time <- paste0(nl1$month, "/", nl1$day, "/", nl1$year)
colnames(nl1)[colnames(nl1) == "NUTS_ID"] <- "geo"
colnames(nl1)[colnames(nl1) == "date"] <- "time"
nl1$frequency <- "Y"
nl1$estimate <- "missing"
nl1$db_source <- "copernicus_forest_cover_data"

n1df <- nl1[,c("indicator_code", "unit", "geo", "time", "value",
				 "year", "month", "day", "frequency", "estimate", 
				 "db_source")]

write.csv(file="nuts1_average_forest_cover.csv", n1df, row.names=FALSE)

#NUTS2
nuts_2$id <- 1:max(nrow(nuts_2)) # common id
nuts2 <- nuts_2 %>% st_as_sf()

nts2  <- exact_extract(ras, nuts2 , "mean")
nts2$id <- 1:max(nrow(nts2)) # common id
nt2 <- melt(data = nts2, id.vars = "id")

# turn variable string into date string
nt2$year <- nt2$variable %>%
           gsub("mean.X", "", .) %>%
           gsub("_forest_cover", "", .) %>% 
           as.numeric()

nl2 <- merge(nt2[,c(1, 3:4)], nuts_2, by="id")
nl2$indicator_code <- "forest_cover_data"
nl2$unit <- "percent"
nl2$month <- 1 # generic values
nl2$day <- 1 # generic values
nl2$time <- paste0(nl2$month, "/", nl2$day, "/", nl2$year)
colnames(nl2)[colnames(nl2) == "NUTS_ID"] <- "geo"
colnames(nl2)[colnames(nl2) == "date"] <- "time"
nl2$frequency <- "Y"
nl2$estimate <- "missing"
nl2$db_source <- "copernicus_forest_cover_data"

n2df <- nl2[,c("indicator_code", "unit", "geo", "time", "value",
				 "year", "month", "day", "frequency", "estimate", 
				 "db_source")]

write.csv(file="nuts2_average_forest_cover.csv", n2df, row.names=FALSE)

#NUTS3
nuts_3$id <- 1:max(nrow(nuts_3)) # common id
nuts3 <- nuts_3 %>% st_as_sf()

nts3  <- exact_extract(ras, nuts3 , "mean")
nts3$id <- 1:max(nrow(nts3)) # common id
nt3 <- melt(data = nts3, id.vars = "id")

# turn variable string into date string
nt3$year <- nt3$variable %>%
           gsub("mean.X", "", .) %>%
           gsub("_forest_cover", "", .) %>% 
           as.numeric()

nl3 <- merge(nt3[,c(1, 3:4)], nuts_3, by="id")
nl3$indicator_code <- "forest_cover_data"
nl3$unit <- "percent"
nl3$month <- 1 # generic values
nl3$day <- 1 # generic values
nl3$time <- paste0(nl3$month, "/", nl3$day, "/", nl3$year)
colnames(nl3)[colnames(nl3) == "NUTS_ID"] <- "geo"
colnames(nl3)[colnames(nl3) == "date"] <- "time"
nl3$frequency <- "Y"
nl3$estimate <- "missing"
nl3$db_source <- "copernicus_forest_cover_data"

n3df <- nl3[,c("indicator_code", "unit", "geo", "time", "value",
				 "year", "month", "day", "frequency", "estimate", 
				 "db_source")]

write.csv(file="nuts3_average_forest_cover.csv", n3df, row.names=FALSE)
