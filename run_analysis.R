run_analysis <- function(){
  source("readData.R")
  readData();
  combined_data <<- combineData();
  means_stds <<- grabMeans(combined_data);
  averages <<- getAverages(means_stds);
  write.table(averages, file='output_table.txt');
  averages;
}