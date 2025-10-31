library(dagitty)
library(ggdag)
library(ggplot2)
library(stringr)


dag <- dagitty('dag {
bb="-3,-0.5,2,1.2"
"Electricity Usage" [exposure,pos="0.177,0.430"]
"Hours Open" [adjusted,pos="-0.357,0.766"]
"Ice Cream Sales" [outcome,pos="-0.892,0.430"]
Temperature [adjusted,pos="-0.357,0.094"]
Weekend [pos="-0.892,0.766"]
"Electricity Usage" -> "Ice Cream Sales"
"Hours Open" -> "Electricity Usage"
"Hours Open" -> "Ice Cream Sales"
Temperature -> "Electricity Usage"
Temperature -> "Ice Cream Sales"
Weekend -> "Hours Open"
Weekend -> "Ice Cream Sales"
}
')

dag <- tidy_dagitty(dag)
dag$data$name <- str_replace_all(dag$data$name, fixed(" "), "\n")
dag$data$to <- str_replace_all(dag$data$to, fixed(" "), "\n")
dag$data$exposure <- ifelse(dag$data$name == "Electricity\nUsage", "Exposure", 
                          ifelse(dag$data$name == "Ice\nCream\nSales", "Outcome", 
                                 ifelse(dag$data$name == "Hours\nOpen"|dag$data$name == "Temperature", "Adjusted", "Other")))

# Use ggdag to plot the DAG
dag_plot <- ggdag(dag, text = FALSE) + 
  geom_dag_node(aes(fill = exposure), shape = 21, color = "black") +
  scale_fill_manual(values = c("Exposure" = "green", "Outcome" ="cyan", "Adjusted"="red", "Other" = "black")) +
  geom_text(data = subset(dag$data, name != "Weekend"&name != "Ice\nCream\nSales"), 
            aes(x = x+0.38, y = y, label = name)) +
  geom_text(data = subset(dag$data, name == "Weekend"|name == "Ice\nCream\nSales"), 
            aes(x = x, y = y, label = name), 
            nudge_x = -0.33, nudge_y = 0) +
  theme_dag() +
  theme(legend.position = "none")

dag_plot

pdf(file = "plots/adjusted_ics.pdf", width = 4, height = 3.5)
dag_plot
dev.off()
