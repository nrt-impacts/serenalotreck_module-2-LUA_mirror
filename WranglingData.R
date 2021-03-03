library(tidyverse)
library(ggplot2)
library(ggpubr)
library(reshape2)

unmeltDF <- function(df, id){
  df[,-c(1)] <- apply(df[,-c(1)], 2, as.numeric)
  #print(df)
  cols= ncol(df)
  rows= nrow(df)
  
  NamesVector <- c()
  NumbersVector <- c()
  for (r in 1:rows){
    for (c in 1:cols){
      names <- paste(row.names(df)[r], colnames(df)[c], sep = "_")
      NamesVector <- c(NamesVector, names)
      #
      val <- as.numeric(df[r,c]) 
      NumbersVector <- c(NumbersVector, val) 
    }
  }
  
  out <- as.data.frame(matrix(0, , nrow = 1, ncol = length(NamesVector)))
  colnames(out) <- NamesVector
  out[1,] <- NumbersVector
  out[,"PlotID"] <- id
  return(out)
}

getColnames <- function(long_colnames){ 
  outnames= vector()
  count=1
  for (i in long_colnames){ 
    c = unlist(strsplit(i,"-",fixed=TRUE)) 
    #c <- c[length(c)-1]
    c <- c[1]
    #c <- paste(c[1:2], sep = "_")
    outnames <- c(outnames, c)
    print(paste(".. working on ", count, " ..", sep = ''))
    count = count+1
  }
  return(outnames)
  }

LAD_GroundData <- as_tibble(read.table("Data/LeafAreaFromDrones/ground_data_2019v3.5.csv", sep = ',', h=T))
colnames(LAD_GroundData)[1] <- "PlotID"

#
LAD_GroundData$plot <- as.character(LAD_GroundData$plot)
#
LAD <- as_tibble(read.table("Data/CanopyHeightArchitecture/point_data_6in_2019obs.csv", sep = ',', h=T))
colnames(LAD)

### mask to filter by day  ####
PreporccesIBGData <- function(DF_raw, day){
  # make mask with day
  mask <- grepl(day, colnames(DF_raw))
  dfClean <- as_tibble(as.data.frame(cbind(DF_raw[,c(1,2)], DF_raw[,mask])))
  dfClean[,"plot_id2"] <- getColnames(as.character(dfClean$plot_id))
  
  Plots <- unique(dfClean$plot_id2)
  #
  Col <- colnames(dfClean[,3:6])
  Metrics <- c("Min", "1stQu", "Median", "Mean", "3rdQu", "Max", "sd")
  Cols <- c()
  for (m in Metrics) {Cols <- c(Cols, paste(m, Col, sep = "_"))}
  Cols <- c(Cols, "PlotID")
  #
  Finalout <- as.data.frame(matrix(0, nrow = 0, ncol = length(Cols)))
  colnames(Finalout) <- Cols
  #print(Finalout)

  for (p in Plots){
    tem <- subset(dfClean, plot_id2 == p)[,3:6]
    out <- as.data.frame(do.call(cbind, lapply(tem, summary)))[1:6,]
    # print(out)
    sd <- do.call(cbind, lapply(tem, sd))
    sd[is.na(sd)] <- 0
    values <- gsub(" ", "", row.names(out))
    values <- gsub("\\.", "", values)
    # print(cor(t(out)))
    row.names(out) <- values
    out <- rbind(out, as.vector(sd))
    row.names(out)[7] <- "sd"
    #
    # out <- as.data.frame(cbind(Values=values, out))
    # print(dim(out))
    out <- unmeltDF(out, p)
    #print(dim(out))
    # out <- out[Cols]
    # print(table(colnames(out)==colnames(Finalout)))
    Finalout <- rbind(Finalout, out)  
    
  }
  return(Finalout)
}


subset(as.data.frame(table(LAD_GroundData[,c(1:2)])), Freq >0)

table(LAD_GroundData$plot)

# Get different dates in dataset with "red signal"
TotalDays <- gsub("RGB_", "", colnames(LAD)[grepl("RGB", colnames(LAD))][grepl("_R", colnames(LAD)[grepl("RGB", colnames(LAD))])])
TotalDays <- gsub("_R", "", TotalDays)
TotalDays



for (d in TotalDays){
  # 
  tem <- PreporccesIBGData(LAD, d)
  #
  tem <- left_join(LAD_GroundData[,c(1:4,21:22)], tem, by="PlotID")
  #
  mask2 <- grepl("_DSM_", colnames(tem)) == "FALSE"
  tem <- tem[,mask2]
  tem <- tem[(is.na(tem[,7])=="FALSE"),]
  #
  write.table(tem, paste("CleanData_InputML", "_", d, "_", ".txt", sep = ""), sep = "\t", quote = F, row.names = F)
  
}

# LADsummary71519 <- PreporccesIBGData(LAD, "7_15_19")
# LADsummary10719 <- PreporccesIBGData(LAD, "10_7_19")
# LADsummary9219 <- PreporccesIBGData(LAD, "9_2_19")
# LADsummary7219 <- PreporccesIBGData(LAD, "7_2_19")

