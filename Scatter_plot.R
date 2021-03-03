library(ggpubr)


Model1 <- read.table("featureTable.txt_RF_scores.txt", sep = '\t', h=T)
Model2 <- read.table("featureTable2.txt_RF_scores.txt", sep = '\t', h=T)
Model3 <- read.table("FinalFeatureTableSeptJulDiff.csv_RF_scores.txt", sep = '\t', h=T)

Plotout <- ggscatter(Model, x = "Y", y="Mean", size = 1,
                     add = "reg.line" # add repression line
                     ) +
                     stat_cor(method = "pearson", label.x = 5000, label.y = 15000)
                     
Plotout2 <- ggscatter(Model2, x = "Y", y="Mean", size = 1,
                      add = "reg.line" # add repression line
                      ) +
  stat_cor(method = "pearson", label.x = 5000, label.y = 15000)

Plotout3 <- ggscatter(Model3, x = "Y", y="Mean", size = 1,
                      add = "reg.line" # add repression line
                      ) +
  stat_cor(method = "pearson", label.x = 5000, label.y = 15000)

Plotout <- ggpar(Plotout, xlab ="True values", ylab="Predicted Values")
Plotout2 <- ggpar(Plotout2, xlab ="True values", ylab="Predicted Values")
Plotout3 <- ggpar(Plotout3, xlab ="True values", ylab="Predicted Values")

ggsave(Plotout, filename ="Model_1.png",width = 15, height = 8, units = "cm")
ggsave(Plotout2, filename ="Model_2.png",width = 15, height = 8, units = "cm")
ggsave(Plotout3, filename ="Model_3.png",width = 15, height = 8, units = "cm")
